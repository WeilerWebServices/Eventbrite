module EventbriteSDK
  # These are general error types given in API responses.
  # See the defined resource for error types that are unique to that resource.

  # The resource is already deleted
  ERROR_ALREADY_DELETED = 'ALREADY_DELETED'.freeze

  # Paginated query had an invalid page, usually out of range
  ERROR_BAD_PAGE = 'BAD_PAGE'.freeze

  # Token was provided, but invalid
  ERROR_BAD_TOKEN = 'INVALID_AUTH'.freeze

  # The requested endpoint or resource does not exist
  ERROR_NOT_FOUND = 'NOT_FOUND'.freeze

  # No token was provided for an endpoint that requires authentication
  ERROR_TOKEN_REQUIRED = 'NO_AUTH'.freeze

  # One of the provided arguments is invalid
  ERROR_ARGUMENTS = 'ARGUMENTS_ERROR'.freeze

  # The package associated to the account does not allow the requested action
  ERROR_NOT_PERMITTED_BY_PACKAGE = 'INSUFFICIENT_PACKAGE'.freeze

  # No package is associated to the account
  ERROR_PACKAGE_NOT_SET = 'NO_PACKAGE_SELECTED'.freeze
end
