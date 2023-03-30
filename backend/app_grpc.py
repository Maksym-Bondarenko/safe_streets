from concurrent import futures
import time
import grpc
from proto import service_pb2, service_pb2_grpc
import logging
import config
from database import DBConnector
from flask import jsonify


class SafeCityService(service_pb2_grpc.SafeCityServiceServicer):

    def __init__(self, db_client: DBConnector):
        # initialize Connector object
        self.db_client = db_client

    def GetAllUsers(self, request, context):
        result = self.db_client.get_all_users()
        users = []
        for row in result:
            users.append(service_pb2.User(id=row[0], full_name=row[1], email=row[2], city_id=row[3]))
        return service_pb2.UserList(users=users)


def grpc_server(dbConnector):
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    # Register user service
    # user_serve = UserService()
    # user_service.add_UserServicer_to_server(user_serve, server)
    server.add_insecure_port('[::]:8080')
    service_pb2_grpc.add_SafeCityServiceServicer_to_server(SafeCityService(dbConnector), server)
    print('server start')
    server.start()
    server.wait_for_termination()


if __name__ == '__main__':
    dbConnector = DBConnector()
    grpc_server(dbConnector)
