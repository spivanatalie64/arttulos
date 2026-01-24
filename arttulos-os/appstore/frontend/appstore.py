import sys
from PyQt5 import QtWidgets, QtGui

class AppStore(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('ArttulOS App Store')
        self.setGeometry(100, 100, 800, 600)
        self.init_ui()

    def init_ui(self):
        layout = QtWidgets.QVBoxLayout()
        self.search_bar = QtWidgets.QLineEdit()
        self.search_bar.setPlaceholderText('Search for apps...')
        self.app_list = QtWidgets.QListWidget()
        self.install_btn = QtWidgets.QPushButton('Install Selected')
        layout.addWidget(self.search_bar)
        layout.addWidget(self.app_list)
        layout.addWidget(self.install_btn)
        self.setLayout(layout)
        # Populate with example apps
        for app in ['Firefox', 'GIMP', 'LibreOffice', 'VLC', 'Thunderbird']:
            self.app_list.addItem(app)

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    store = AppStore()
    store.show()
    sys.exit(app.exec_())
