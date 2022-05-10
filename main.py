# This Python file uses the following encoding: utf-8
import sys
import os
from Crypto.Cipher import DES3
from Crypto.Random import get_random_bytes

from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QObject, pyqtSlot


class Crypter(QObject):
    @pyqtSlot(result=str)
    def generate(self):
        while True:
            try:
                key = DES3.adjust_key_parity(get_random_bytes(24))
                break
            except ValueError:
                pass
        return str(key.hex())

    @pyqtSlot(str, str, result=str)
    def encrypt(self, msg, key):
        try:
            key = bytes.fromhex(key)
            cipher = DES3.new(key, DES3.MODE_EAX)
            self.nonce = cipher.nonce
            msg_crypt = cipher.encrypt(msg.encode('ascii'))
            return str(msg_crypt.hex())
        except:
            return 'Error'

    @pyqtSlot(str, str, result=str)
    def decrypt(self, msg, key):
        try:
            cipher = DES3.new(bytes.fromhex(key), DES3.MODE_EAX, nonce=self.nonce)
            msg = cipher.decrypt(bytes.fromhex(msg))
            res = msg.decode('ascii')
            return res
        except:
            return 'Error'


if __name__ == "__main__":
    crypter = Crypter()


    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon('icon.png'))
    engine = QQmlApplicationEngine()

    ctx = engine.rootContext()
    ctx.setContextProperty('crypter', crypter)

    engine.load(os.path.join(os.path.dirname(__file__), "main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
