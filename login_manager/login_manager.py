
import sys
from PyQt5 import QtWidgets, QtGui, QtCore, uic
from onboarding_wizard import OnboardingWizard
from accessibility import AccessibilityOptions

class LoginManager(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        # Use absolute path for .ui file for reliability
        import os
        ui_path = os.path.join(os.path.dirname(__file__), 'login_manager.ui')
        uic.loadUi(ui_path, self)
        self.accessibility = AccessibilityOptions(self)
        # Defensive: check widget existence before connecting
        try:
            self.loginBtn.clicked.connect(self.authenticate)
            self.onboardBtn.clicked.connect(self.launch_onboarding)
            self.accessBtn.clicked.connect(self.accessibility.show_options)
        except AttributeError as e:
            QtWidgets.QMessageBox.critical(self, 'UI Error', f'Missing widget: {e}')

    def authenticate(self):
        # Placeholder: Replace with real authentication
        user = self.userInput.text()
        passwd = self.passInput.text()
        if user == 'user' and passwd == 'pass':
            QtWidgets.QMessageBox.information(self, 'Login', 'Login successful!')
            QtCore.QCoreApplication.quit()
        else:
            QtWidgets.QMessageBox.warning(self, 'Login', 'Invalid credentials.')

    def launch_onboarding(self):
        wizard = OnboardingWizard(self)
        wizard.exec_()

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    login = LoginManager()
    login.showFullScreen()
    sys.exit(app.exec_())
