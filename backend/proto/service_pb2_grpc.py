# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc

from . import service_pb2 as service__pb2


class SafeCityServiceStub(object):
    """Missing associated documentation comment in .proto file."""

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.AddUser = channel.unary_unary(
                '/SafeCity.SafeCityService/AddUser',
                request_serializer=service__pb2.User.SerializeToString,
                response_deserializer=service__pb2.GenericResponse.FromString,
                )
        self.UpdateUser = channel.unary_unary(
                '/SafeCity.SafeCityService/UpdateUser',
                request_serializer=service__pb2.User.SerializeToString,
                response_deserializer=service__pb2.GenericResponse.FromString,
                )
        self.GetAllUsers = channel.unary_unary(
                '/SafeCity.SafeCityService/GetAllUsers',
                request_serializer=service__pb2.Empty.SerializeToString,
                response_deserializer=service__pb2.UserList.FromString,
                )
        self.AddBadPlace = channel.unary_unary(
                '/SafeCity.SafeCityService/AddBadPlace',
                request_serializer=service__pb2.BadPlace.SerializeToString,
                response_deserializer=service__pb2.GenericResponse.FromString,
                )
        self.UpdateBadPlace = channel.unary_unary(
                '/SafeCity.SafeCityService/UpdateBadPlace',
                request_serializer=service__pb2.BadPlace.SerializeToString,
                response_deserializer=service__pb2.GenericResponse.FromString,
                )
        self.DeleteBadPlace = channel.unary_unary(
                '/SafeCity.SafeCityService/DeleteBadPlace',
                request_serializer=service__pb2.BadPlace.SerializeToString,
                response_deserializer=service__pb2.GenericResponse.FromString,
                )
        self.GetAllBadPlaces = channel.unary_unary(
                '/SafeCity.SafeCityService/GetAllBadPlaces',
                request_serializer=service__pb2.Empty.SerializeToString,
                response_deserializer=service__pb2.BadPlaceList.FromString,
                )


class SafeCityServiceServicer(object):
    """Missing associated documentation comment in .proto file."""

    def AddUser(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def UpdateUser(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def GetAllUsers(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def AddBadPlace(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def UpdateBadPlace(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def DeleteBadPlace(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def GetAllBadPlaces(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_SafeCityServiceServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'AddUser': grpc.unary_unary_rpc_method_handler(
                    servicer.AddUser,
                    request_deserializer=service__pb2.User.FromString,
                    response_serializer=service__pb2.GenericResponse.SerializeToString,
            ),
            'UpdateUser': grpc.unary_unary_rpc_method_handler(
                    servicer.UpdateUser,
                    request_deserializer=service__pb2.User.FromString,
                    response_serializer=service__pb2.GenericResponse.SerializeToString,
            ),
            'GetAllUsers': grpc.unary_unary_rpc_method_handler(
                    servicer.GetAllUsers,
                    request_deserializer=service__pb2.Empty.FromString,
                    response_serializer=service__pb2.UserList.SerializeToString,
            ),
            'AddBadPlace': grpc.unary_unary_rpc_method_handler(
                    servicer.AddBadPlace,
                    request_deserializer=service__pb2.BadPlace.FromString,
                    response_serializer=service__pb2.GenericResponse.SerializeToString,
            ),
            'UpdateBadPlace': grpc.unary_unary_rpc_method_handler(
                    servicer.UpdateBadPlace,
                    request_deserializer=service__pb2.BadPlace.FromString,
                    response_serializer=service__pb2.GenericResponse.SerializeToString,
            ),
            'DeleteBadPlace': grpc.unary_unary_rpc_method_handler(
                    servicer.DeleteBadPlace,
                    request_deserializer=service__pb2.BadPlace.FromString,
                    response_serializer=service__pb2.GenericResponse.SerializeToString,
            ),
            'GetAllBadPlaces': grpc.unary_unary_rpc_method_handler(
                    servicer.GetAllBadPlaces,
                    request_deserializer=service__pb2.Empty.FromString,
                    response_serializer=service__pb2.BadPlaceList.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'SafeCity.SafeCityService', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))


 # This class is part of an EXPERIMENTAL API.
class SafeCityService(object):
    """Missing associated documentation comment in .proto file."""

    @staticmethod
    def AddUser(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/SafeCity.SafeCityService/AddUser',
            service__pb2.User.SerializeToString,
            service__pb2.GenericResponse.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def UpdateUser(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/SafeCity.SafeCityService/UpdateUser',
            service__pb2.User.SerializeToString,
            service__pb2.GenericResponse.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def GetAllUsers(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/SafeCity.SafeCityService/GetAllUsers',
            service__pb2.Empty.SerializeToString,
            service__pb2.UserList.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def AddBadPlace(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/SafeCity.SafeCityService/AddBadPlace',
            service__pb2.BadPlace.SerializeToString,
            service__pb2.GenericResponse.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def UpdateBadPlace(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/SafeCity.SafeCityService/UpdateBadPlace',
            service__pb2.BadPlace.SerializeToString,
            service__pb2.GenericResponse.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def DeleteBadPlace(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/SafeCity.SafeCityService/DeleteBadPlace',
            service__pb2.BadPlace.SerializeToString,
            service__pb2.GenericResponse.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def GetAllBadPlaces(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/SafeCity.SafeCityService/GetAllBadPlaces',
            service__pb2.Empty.SerializeToString,
            service__pb2.BadPlaceList.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)