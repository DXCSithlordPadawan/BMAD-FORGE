---
name: api-documentation-template
description: API documentation template for describing endpoints, authentication, request/response formats, and usage examples.
roles:
  - architect
  - developer
workflow_phase: development
category: technical

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the technical documentation specialist persona"
    keywords_required:
      - "API"
      - "documentation"
    keywords_recommended:
      - "endpoints"
      - "authentication"
      - "developers"
    validation_severity: critical
    examples:
      - "Act as a technical documentation specialist who creates comprehensive API documentation including endpoints, authentication, and usage examples."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for API documentation"
    keywords_required:
      - "API"
    keywords_recommended:
      - "endpoints"
      - "authentication"
      - "request"
      - "response"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected API documentation deliverables"
    keywords_required:
      - "endpoints"
    keywords_recommended:
      - "authentication"
      - "examples"
      - "errors"
    validation_severity: critical

variables:
  API_NAME:
    description: "Name of the API being documented"
    required: true
    type: text
    placeholder: "API Name"
    help_text: "Enter the official API name"

  AUTHOR_NAME:
    description: "Document author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  API_VERSION:
    description: "API version"
    required: true
    type: text
    validation: "^v?[0-9]+\\.[0-9]+.*$"
    placeholder: "v1.0"
    help_text: "Enter the API version (e.g., v1.0, 2.1.0)"

  AUTH_TYPE:
    description: "Primary authentication type"
    required: false
    type: select
    options:
      - "API Key"
      - "OAuth 2.0"
      - "JWT"
      - "Basic Auth"
      - "None"
    default: "API Key"

  BASE_URL:
    description: "API base URL"
    required: false
    type: text
    placeholder: "https://api.example.com/v1"
---

## Your Role

Act as a technical documentation specialist who creates comprehensive API documentation. You document endpoints, authentication methods, request/response formats, and usage examples to enable developers to integrate with and consume APIs effectively.

## Input

You expect to receive:
- API endpoint specifications and schemas
- Authentication and authorization requirements
- Request and response format details
- Error codes and handling information
- Usage examples and integration scenarios

## Output Requirements

Your output will include:
- Complete API overview with purpose and architecture
- Detailed authentication documentation with code examples
- Comprehensive endpoint specifications for all HTTP methods
- Error message catalog with troubleshooting guidance
- Integration examples and best practices

---

# API Documentation
Author:Your Name Here

---

## Overview
This section provides a high-level summary of your API. It should include the purpose of the API, its core functionalities, and a brief overview of the architecture. An effective overview helps users quickly understand the value and scope of the API and how it fits into their workflow.

### API Purpose
- Clearly articulate what the API is designed to do.
- Describe the key problems it solves.
- Mention primary use cases.

### Core Functionalities
- List the main features of the API.
- Highlight any unique or advanced functionalities.
- Provide examples of what can be achieved.

### Architecture Overview
- Give a brief overview of the API's architecture.
- Mention any core components or dependencies.
- Note scalability or performance considerations.

## API Authentication
In this section, describe how users can authenticate with your API. Include detailed information on required API keys, tokens, or secrets. Clear instructions on the authentication process ensure users can securely access the API and utilize its functionalities without friction. Security considerations and best practices should also be addressed.

### Authentication Methods
- List supported authentication methods (e.g., API keys, OAuth).
- Provide step-by-step instructions for each method.
- Include code snippets for common programming languages.

### Token Management
- Describe how to obtain and refresh tokens.
- Explain token expiration policies.
- Include best practices for secure token storage.

### Common Issues and Troubleshooting
- List common authentication errors and their solutions.
- Provide tips for debugging authentication issues.
- Link to additional resources or support.

## Error Messages
This section should list all possible error codes and messages that your API might return. Each error should include an explanation of why it might occur and steps users can take to troubleshoot and resolve issues. Comprehensive error documentation aids developers in diagnosing problems quickly and integrating the API smoothly into their applications.

### Error Code List
- Provide a table of all error codes.
- Include corresponding error messages and descriptions.
- Group errors by category (e.g., client-side, server-side).

### Troubleshooting Guide
- Offer solutions or workarounds for common errors.
- Describe scenarios in which each error might occur.
- Recommend best practices to avoid common mistakes.

### Support and Resources
- Link to additional support resources (e.g., forums, FAQs).
- Provide contact information for escalated support.
- Suggest external tools and libraries for debugging.

---

## API Endpoints and Operations
Detailed descriptions of all the available endpoints, their HTTP methods, expected inputs and outputs, and usage examples should be included in this section. This is arguably the most important part of your API documentation. Clear and comprehensive endpoint documentation ensures that users can leverage your API's full potential effectively and efficiently.

### GET
- Define what this method does and the scenario it should be used in.
- List required and optional parameters.
- Offer example requests and sample responses.
- Provide links to additional resources or related endpoints.

### POST
- Describe the purpose of this method and when to use it.
- Detail the necessary input data and format.
- Show example requests and responses.
- Highlight any side effects or additional actions triggered.

### PUT
- Explain the primary function of this method.
- Specify the required parameters and their format.
- Offer sample usage with requests and responses.
- Mention any idempotent properties or key considerations.

### DELETE
- Outline the purpose and typical use cases.
- List input parameters and expected behaviors.
- Provide example requests and responses.
- Discuss any implications or follow-up actions.

---
