from flask import Flask,Blueprint
import requests
import os

ukraine_war = Blueprint("ukraine_war", __name__)

@ukraine_war.route("/ukrainewar")
def get_ukraine_war():
    return _get_ukraine_war()


def _get_ukraine_war():
    url = "https://ukraine-war-live6.p.rapidapi.com/news/guardian"
    headers = {
    "X-RapidAPI-Key": os.environ.get("RAPID_API_KEY"),
    "X-RapidAPI-Host": "ukraine-war-live6.p.rapidapi.com"
    }
    response = requests.get(url, headers=headers)
    return response.json()



