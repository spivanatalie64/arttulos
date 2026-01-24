import sys
from PyQt5 import QtWidgets

class WidgetsLauncher(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('ArttulOS Widgets')
        self.setGeometry(200, 200, 400, 300)
        self.init_ui()

    def init_ui(self):
        layout = QtWidgets.QVBoxLayout()
        self.weather_btn = QtWidgets.QPushButton('Weather')
        self.sysinfo_btn = QtWidgets.QPushButton('System Info')
        layout.addWidget(self.weather_btn)
        layout.addWidget(self.sysinfo_btn)
        self.setLayout(layout)
        # Connect buttons to placeholder actions
        self.weather_btn.clicked.connect(lambda: QtWidgets.QMessageBox.information(self, 'Weather', 'Weather widget coming soon!'))
        self.sysinfo_btn.clicked.connect(lambda: QtWidgets.QMessageBox.information(self, 'System Info', 'System info widget coming soon!'))

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    launcher = WidgetsLauncher()
    launcher.show()
    sys.exit(app.exec_())
