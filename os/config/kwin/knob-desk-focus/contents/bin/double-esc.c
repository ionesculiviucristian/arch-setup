// Watches keyboards (read-only, keys still reach apps); a double Escape runs the KnobDeskFocus KWin shortcut.
#include <fcntl.h>
#include <glob.h>
#include <linux/input.h>
#include <poll.h>
#include <signal.h>
#include <spawn.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define MAX_KBDS 16
#define DOUBLE_PRESS_MS 400
#define RESCAN_MS 5000

extern char **environ;

static struct pollfd fds[MAX_KBDS];
static char paths[MAX_KBDS][256];
static int count;

static long now_ms(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
}

static void open_keyboards(void) {
    glob_t g;
    if (glob("/dev/input/by-id/*-event-kbd", 0, NULL, &g) != 0) {
        return;
    }
    for (size_t i = 0; i < g.gl_pathc && count < MAX_KBDS; i++) {
        char real[256];
        if (!realpath(g.gl_pathv[i], real)) {
            continue;
        }
        int known = 0;
        for (int k = 0; k < count; k++) {
            known |= strcmp(paths[k], real) == 0;
        }
        int fd = known ? -1 : open(real, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
        if (fd >= 0) {
            fds[count] = (struct pollfd){.fd = fd, .events = POLLIN};
            strcpy(paths[count++], real);
        }
    }
    globfree(&g);
}

static void close_keyboard(int k) {
    close(fds[k].fd);
    count--;
    fds[k] = fds[count];
    strcpy(paths[k], paths[count]);
}

static void run_action(void) {
    char *argv[] = {"qdbus6", "org.kde.kglobalaccel", "/component/kwin",
                    "org.kde.kglobalaccel.Component.invokeShortcut", "KnobDeskFocus", NULL};
    pid_t pid;
    posix_spawnp(&pid, argv[0], NULL, NULL, argv, environ);
}

int main(void) {
    signal(SIGCHLD, SIG_IGN);
    long last_esc = 0, last_scan = 0;
    for (;;) {
        if (now_ms() - last_scan > RESCAN_MS) {
            open_keyboards();
            last_scan = now_ms();
        }
        if (poll(fds, count, RESCAN_MS) <= 0) {
            continue;
        }
        for (int k = count - 1; k >= 0; k--) {
            if (fds[k].revents & (POLLERR | POLLHUP | POLLNVAL)) {
                close_keyboard(k);
                continue;
            }
            if (!(fds[k].revents & POLLIN)) {
                continue;
            }
            struct input_event ev[64];
            ssize_t n = read(fds[k].fd, ev, sizeof ev);
            if (n < 0) {
                close_keyboard(k);
                continue;
            }
            for (size_t i = 0; i < n / sizeof *ev; i++) {
                if (ev[i].type != EV_KEY || ev[i].code != KEY_ESC || ev[i].value != 1) {
                    continue;
                }
                long now = now_ms();
                if (now - last_esc < DOUBLE_PRESS_MS) {
                    last_esc = 0;
                    run_action();
                } else {
                    last_esc = now;
                }
            }
        }
    }
}
