class InvalidClientEmail(Exception):
    def __init__(self, message):
        self.title = "Invalid Client Email"
        self.message = message
        self.status = 401
