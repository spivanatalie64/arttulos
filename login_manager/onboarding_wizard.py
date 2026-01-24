from PyQt5 import QtWidgets

class OnboardingWizard(QtWidgets.QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle('ArttulOS Onboarding')
        self.setStyleSheet('background-color: #232323; color: #00FFD0;')
        self.init_ui()

    def init_ui(self):
        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(QtWidgets.QLabel('Welcome to ArttulOS!'))
        layout.addWidget(QtWidgets.QLabel('Let’s set up your user account and preferences.'))
        self.user_input = QtWidgets.QLineEdit()
        self.user_input.setPlaceholderText('Choose a username')
        self.pass_input = QtWidgets.QLineEdit()
        self.pass_input.setPlaceholderText('Choose a password')
        self.pass_input.setEchoMode(QtWidgets.QLineEdit.Password)
        self.finish_btn = QtWidgets.QPushButton('Finish Setup')
        self.finish_btn.clicked.connect(self.accept)
        layout.addWidget(self.user_input)
        layout.addWidget(self.pass_input)
        layout.addWidget(self.finish_btn)
        self.setLayout(layout)
