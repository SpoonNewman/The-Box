from routes import ukraine, catfacts
from flask import Flask


app = Flask(__name__)

app.register_blueprint(catfacts.cat_facts)
app.register_blueprint(ukraine.ukraine_war)


@app.route("/")
def main():
    return "<p>Hello, World!</p>"




















