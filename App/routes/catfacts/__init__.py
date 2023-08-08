from flask import Flask, Blueprint
import requests
import os

cat_facts = Blueprint("cat_facts", __name__)

@cat_facts.route("/catfacts")
def get_cat_facts():
    return _get_cat_facts()



def _get_cat_facts():
    url = "https://random-cat-fact.p.rapidapi.com/"

    headers = {
        "X-RapidAPI-Key": os.environ.get("RAPID_API_KEY"),
        "X-RapidAPI-Host": "random-cat-fact.p.rapidapi.com"
    }

    response = requests.get(url, headers=headers)

    return response.json()
