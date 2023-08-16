import datetime
import os
from database import DBConnector
from flask import Flask, jsonify, request
from db_strcuts import User, Place, asdict
import pandas as pd
import json
app = Flask(__name__)

db_client = DBConnector()

df_places = pd.read_csv('safe_points/places_data.csv')


@app.route('/add/user', methods=['POST'])  # documented
def create_user():
    print(request)
    data = request.get_json()
    print(data)
    try:
        db_client.add_user(User(id=None, created_at=None, **data))
        response = jsonify({'status': 'success'})
    except Exception as e:
        response = jsonify({'status': 'fail', 'error': str(e)})

    return response


@app.route("/get/all_users")
def get_all_users():
    result = db_client.get_all_users()
    return json.dumps(result)
    # users = [asdict(User(**row)) for row in result]
    # return jsonify(users)


@app.route("/get/safe_places", methods=['GET'])
def get_safe_places():
    return df_places.to_json(orient='records')


# get user by firebase id
@app.route("/get/user")  # documented
def get_users_by_firebase_user_id():
    args = request.args.to_dict()
    firebase_user_id = args.get('firebase_user_id')
    if firebase_user_id is None:
        return jsonify({'status': 'not found', 'message': 'provide firebase_user_id'})
    result = db_client.get_users(firebase_user_id)
    users = [asdict(User(**row)) for row in result]
    return jsonify(users)


# delete by id or firebase id
@app.route("/delete/user", methods=['POST'])  # documented
def delete_user():
    data = request.get_json()
    firebase_user_id = data.get('firebase_user_id')
    id = data.get('id')
    if firebase_user_id is not None:
        db_client.delete_user(firebase_user_id)

    if id is not None:
        db_client.delete_user(id)
    return jsonify({'status': 'success'})


@app.route('/add/place', methods=['POST'])  # documented
def create_place():
    data = request.get_json()
    db_client.add_location(Place(id=None, created_at=None, **data))
    return jsonify({'status': 'success'})


@app.route("/get/places", methods=['GET'])
def get_places():
    args = request.args.to_dict()
    main_type = args.get('main_type')
    sub_type = args.get('sub_type')
    firebase_user_id = args.get('firebase_user_id')
    result = db_client.get_places(main_type, sub_type, firebase_user_id)
    places = [asdict(Place(**row)) for row in result]
    return jsonify(places)


@app.route("/delete/place", methods=['POST'])
def delete_place():
    data = request.get_json()
    db_client.delete_place(data['id'])
    return jsonify({'status': 'success'})


@app.route("/update/place/likes", methods=['POST'])
def update_place_like():
    data = request.get_json()
    db_client.update_like(data['id'])
    return jsonify({'status': 'success'})


@app.route("/update/place/dislikes", methods=['POST'])
def update_place_dislike():
    data = request.get_json()
    db_client.udpate_dislike(data['id'])
    return jsonify({'status': 'success'})


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))

# TODO: check that this point belongs to a user, return all points from specific user + upvote/downvote + flag not interested (or mute notification).
