#!/usr/bin/python3
# Password dialog for desktop 2; on success asks KWin (Desk2Unlocked shortcut) to switch.
import getpass
import subprocess
import sys

from PySide6.QtCore import Qt
from PySide6.QtGui import QAction, QFont, QIcon
from PySide6.QtWidgets import (QApplication, QDialog, QDialogButtonBox, QHBoxLayout, QLabel, QLineEdit,
                               QVBoxLayout)

MAX_TRIES = 3


def password_ok(password: str) -> bool:
    result = subprocess.run(["/usr/bin/unix_chkpwd", getpass.getuser(), "nullok"],
                            input=password.encode() + b"\0")
    return result.returncode == 0


class AuthDialog(QDialog):
    def __init__(self):
        super().__init__()
        self.tries_left = MAX_TRIES
        self.setWindowTitle("Authentication Required")
        self.setWindowIcon(QIcon.fromTheme("dialog-password"))
        self.setWindowFlag(Qt.WindowType.WindowStaysOnTopHint)
        self.setFixedWidth(420)

        icon = QLabel()
        icon.setPixmap(QIcon.fromTheme("dialog-password").pixmap(64, 64))
        icon.setAlignment(Qt.AlignmentFlag.AlignTop)

        title = QLabel("Authentication required")
        title_font = QFont(title.font())
        title_font.setPointSizeF(title_font.pointSizeF() * 1.35)
        title_font.setBold(True)
        title.setFont(title_font)

        subtitle = QLabel(f"Enter the password for <b>{getpass.getuser()}</b> to continue.")
        subtitle.setWordWrap(True)

        self.password = QLineEdit()
        self.password.setEchoMode(QLineEdit.EchoMode.Password)
        self.password.setPlaceholderText("Password")
        self.password.setMinimumHeight(34)
        self.password.textEdited.connect(lambda: self.error.hide())
        reveal = QAction(QIcon.fromTheme("view-visible"), "Show password", self.password)
        reveal.setCheckable(True)
        reveal.toggled.connect(self.toggle_reveal)
        self.password.addAction(reveal, QLineEdit.ActionPosition.TrailingPosition)

        self.error = QLabel()
        self.error.setStyleSheet("color: #da4453;")
        self.error.hide()

        buttons = QDialogButtonBox(QDialogButtonBox.StandardButton.Ok | QDialogButtonBox.StandardButton.Cancel)
        buttons.button(QDialogButtonBox.StandardButton.Ok).setText("Unlock")
        buttons.button(QDialogButtonBox.StandardButton.Ok).setIcon(QIcon.fromTheme("unlock"))
        buttons.accepted.connect(self.check)
        buttons.rejected.connect(self.reject)

        text = QVBoxLayout()
        text.setSpacing(6)
        text.addWidget(title)
        text.addWidget(subtitle)
        text.addSpacing(10)
        text.addWidget(self.password)
        text.addWidget(self.error)

        body = QHBoxLayout()
        body.setSpacing(18)
        body.addWidget(icon)
        body.addLayout(text, 1)

        root = QVBoxLayout(self)
        root.setContentsMargins(24, 22, 24, 18)
        root.setSpacing(18)
        root.addLayout(body)
        root.addWidget(buttons)

        self.password.setFocus()

    def toggle_reveal(self, shown: bool):
        self.password.setEchoMode(QLineEdit.EchoMode.Normal if shown else QLineEdit.EchoMode.Password)

    def check(self):
        if password_ok(self.password.text()):
            self.accept()
            return
        self.tries_left -= 1
        if self.tries_left == 0:
            self.reject()
            return
        self.password.clear()
        self.error.setText(f"Incorrect password. {self.tries_left} attempt{'s' if self.tries_left > 1 else ''} left.")
        self.error.show()


app = QApplication(sys.argv)
dialog = AuthDialog()
if dialog.exec() != QDialog.DialogCode.Accepted:
    sys.exit(1)
subprocess.run(["qdbus6", "org.kde.kglobalaccel", "/component/kwin",
                "org.kde.kglobalaccel.Component.invokeShortcut", "Desk2Unlocked"])
