from http.server import BaseHTTPRequestHandler, HTTPServer
import cgi

PORT = 80
PORTAL_PATH = 'portal.html'
PASSWORD_HASH = 'hashed_password_here'  # Replace with the hashed password

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            try:
                with open(PORTAL_PATH, 'r') as file:
                    self.wfile.write(file.read().encode())
            except FileNotFoundError:
                self.wfile.write(b'Error: Portal file not found')
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        if self.path == '/login':
            form = cgi.FieldStorage(fp=self.rfile, headers=self.headers, environ={'REQUEST_METHOD': 'POST'})
            password = form.getvalue('password')
            if password and self.verify_password(password):
                self.send_response(200)
                self.send_header('Content-type', 'text/html')
                self.end_headers()
                self.wfile.write(b'<html><body><h1>Connected, you now have access to the internet!</h1></body></html>')
            else:
                self.send_response(401)
                self.send_header('Content-type', 'text/html')
                self.end_headers()
                self.wfile.write(b'<html><body><h1>Denied, please retry!</h1></body></html>')
        else:
            self.send_response(404)
            self.end_headers()

    def verify_password(self, input_password):
        # Implement your secure password verification logic here
        # For example, compare the hashed version of the input password with PASSWORD_HASH
        return input_password == 'YourPassword'  # Replace with your secure comparison logic

def run(server_class=HTTPServer, handler_class=RequestHandler, port=PORT):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting httpd on port: {port}, please wait...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()
