# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: employees/v1/employees.proto
"""Generated protocol buffer code."""
from google.protobuf.internal import builder as _builder
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import symbol_database as _symbol_database
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from google.api import annotations_pb2 as google_dot_api_dot_annotations__pb2


DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x1c\x65mployees/v1/employees.proto\x12\x0c\x65mployees.v1\x1a\x1cgoogle/api/annotations.proto\"(\n\x12GetEmployeeRequest\x12\x12\n\nshort_name\x18\x01 \x01(\t\"\x90\x01\n\x13GetEmployeeResponse\x12<\n\x08\x65mployee\x18\x01 \x01(\x0b\x32*.employees.v1.GetEmployeeResponse.Employee\x1a;\n\x08\x45mployee\x12\n\n\x02id\x18\x01 \x01(\x03\x12\x11\n\tfull_name\x18\x02 \x01(\t\x12\x10\n\x08\x62irthday\x18\x03 \x01(\t\"\x16\n\x14ListEmployeesRequest\",\n\x15ListEmployeesResponse\x12\x13\n\x0bshort_names\x18\x01 \x03(\t2\x98\x02\n\x10\x45mployeesService\x12\x83\x01\n\x0bGetEmployee\x12 .employees.v1.GetEmployeeRequest\x1a!.employees.v1.GetEmployeeResponse\"/\x82\xd3\xe4\x93\x02)\x12\'/employees/v1/get_employee/{short_name}\x12~\n\rListEmployees\x12\".employees.v1.ListEmployeesRequest\x1a#.employees.v1.ListEmployeesResponse\"$\x82\xd3\xe4\x93\x02\x1e\x12\x1c/employees/v1/list_employeesBCZAgithub.com/opensourcecorp/workshops/protobuf-grpc/pb/employees/v1b\x06proto3')

_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, globals())
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'employees.v1.employees_pb2', globals())
if _descriptor._USE_C_DESCRIPTORS == False:

  DESCRIPTOR._options = None
  DESCRIPTOR._serialized_options = b'ZAgithub.com/opensourcecorp/workshops/protobuf-grpc/pb/employees/v1'
  _EMPLOYEESSERVICE.methods_by_name['GetEmployee']._options = None
  _EMPLOYEESSERVICE.methods_by_name['GetEmployee']._serialized_options = b'\202\323\344\223\002)\022\'/employees/v1/get_employee/{short_name}'
  _EMPLOYEESSERVICE.methods_by_name['ListEmployees']._options = None
  _EMPLOYEESSERVICE.methods_by_name['ListEmployees']._serialized_options = b'\202\323\344\223\002\036\022\034/employees/v1/list_employees'
  _GETEMPLOYEEREQUEST._serialized_start=76
  _GETEMPLOYEEREQUEST._serialized_end=116
  _GETEMPLOYEERESPONSE._serialized_start=119
  _GETEMPLOYEERESPONSE._serialized_end=263
  _GETEMPLOYEERESPONSE_EMPLOYEE._serialized_start=204
  _GETEMPLOYEERESPONSE_EMPLOYEE._serialized_end=263
  _LISTEMPLOYEESREQUEST._serialized_start=265
  _LISTEMPLOYEESREQUEST._serialized_end=287
  _LISTEMPLOYEESRESPONSE._serialized_start=289
  _LISTEMPLOYEESRESPONSE._serialized_end=333
  _EMPLOYEESSERVICE._serialized_start=336
  _EMPLOYEESSERVICE._serialized_end=616
# @@protoc_insertion_point(module_scope)
