import datetime
import os
from database import DBConnector
from flask import Flask, jsonify, request
from db_strcuts import User, Place, City, asdict

app = Flask(__name__)

db_client = DBConnector()


@app.route('/add/user', methods=['POST'])
def create_user():
    print(request)
    data = request.get_json()
    print(data)
    db_client.add_user(User(id=None, created_at=None, **data))
    return jsonify({'status': 'success'})


@app.route("/get/all_users")
def get_all_users():
    result = db_client.get_all_users()
    users = [asdict(User(**row)) for row in result]
    return jsonify(users)


@app.route("/delete/user", methods=['POST'])
def delete_user():
    data = request.get_json()
    db_client.delete_user(data['id'])
    return jsonify({'status': 'success'})


@app.route('/add/place', methods=['POST'])
def create_place():
    data = request.get_json()
    db_client.add_location(Place(id=None, created_at=None, **data))
    return jsonify({'status': 'success'})


@app.route("/get/all_places", methods=['GET'])
def get_all_places():
    args = request.args.to_dict()
    danger_ranking = args.get('danger_ranking')
    type = args.get('type')
    user_id = args.get('user_id')
    result = db_client.get_all_places(danger_ranking, type, user_id)
    places = [asdict(Place(**row)) for row in result]
    return jsonify(places)


@app.route("/delete/place", methods=['POST'])
def delete_place():
    data = request.get_json()
    db_client.delete_place(data['id'])
    return jsonify({'status': 'success'})


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
