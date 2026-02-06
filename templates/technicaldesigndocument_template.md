---
name: technical-design-document-template
description: Technical design document template for documenting system architecture, components, and implementation details.
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
    help_text: "Define the technical architect persona for design documentation"
    keywords_required:
      - "technical"
      - "design"
    keywords_recommended:
      - "architecture"
      - "components"
      - "implementation"
    validation_severity: critical
    examples:
      - "Act as a technical architect who creates comprehensive technical design documents including system architecture, components, and implementation details."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for technical design"
    keywords_required:
      - "requirements"
    keywords_recommended:
      - "architecture"
      - "technology"
      - "performance"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected technical design deliverables"
    keywords_required:
      - "design"
    keywords_recommended:
      - "architecture"
      - "testing"
      - "deployment"
    validation_severity: critical

variables:
  SYSTEM_NAME:
    description: "Name of the system being designed"
    required: true
    type: text
    placeholder: "System Name"

  AUTHOR_NAME:
    description: "Document author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  TECH_STACK:
    description: "Primary technology stack"
    required: false
    type: multiselect
    options:
      - "Python"
      - "JavaScript/TypeScript"
      - "Java"
      - "Go"
      - "Rust"
      - "C#/.NET"
      - "Ruby"

  ARCHITECTURE_PATTERN:
    description: "Primary architecture pattern"
    required: false
    type: select
    options:
      - "Microservices"
      - "Monolithic"
      - "Serverless"
      - "Event-Driven"
      - "Layered"
      - "Hexagonal"
    default: "Layered"

  DATABASE_TYPE:
    description: "Primary database type"
    required: false
    type: select
    options:
      - "PostgreSQL"
      - "MySQL"
      - "MongoDB"
      - "Redis"
      - "DynamoDB"
      - "SQLite"
    default: "PostgreSQL"
---

## Your Role

Act as a technical architect who creates comprehensive technical design documents. You document system architecture, components, data structures, and implementation details to provide a clear blueprint for development teams.

## Input

You expect to receive:
- Product requirements and specifications
- System architecture constraints
- Technology stack preferences
- Performance and scalability requirements
- Integration and deployment considerations

## Output Requirements

Your output will include:
- Product overview with purpose, target audience, and expected outcomes
- Design details including architecture, data structures, and interfaces
- Comprehensive testing plan with strategies, tools, and test cases
- Deployment plan with environment setup and verification steps
- Documentation of algorithms, patterns, and design decisions

---

# Technical Design Document
Author:Your Name Here

---

## Product Overview
This section provides a concise summary of the product or feature. Outline its purpose, the specific user needs it addresses, and the expected outcomes from its use. High-level context will help stakeholders understand the product's strategic value.

### Purpose
- Define the primary purpose of the product or feature.
- Explain the problem it solves or the opportunity it captures.- 
Concretize with examples or scenarios.

### Target Audience
- Identify the key user personas.
- Discuss their needs, pain points, and how the product addresses them.
- Mention any relevant market segments.

### Expected Outcomes
- Specify the tangible and intangible benefits of the product.
- Discuss any key metrics or KPIs that will measure the success.
- Address both short-term and long-term impacts.

---

## Design Details
This section should outline the product's design in detail. Describe the structure, interactions between different components, data structures, and algorithms that will be used. It provides a clear blueprint for development and helps ensure the design aligns with the product goals.

### Architectural Overview
- Provide a high-level diagram of the product architecture.
- Describe how different components communicate with each other.
- Highlight any design patterns or principles used.

### Data Structures and Algorithms
- Detail the data structures and algorithms that will underpin the product.
- Justify their selection in the context of the product goals.
- Discuss efficiency, scalability, and performance considerations.

### System Interfaces
- Describe the various system interfaces involved.
- Include details on API endpoints, third-party services, and internal modules.
- Note any standards or protocols followed.

### User Interfaces
- Outline the main user interface components.
- Provide wireframes or mockups if available.
- Explain how the UI aligns with user needs and product goals.

### Hardware Interfaces
- Detail any hardware interfaces that are relevant.
- Mention specific hardware components or devices that interact with the product.
- Discuss communication protocols or data exchange methods.

---

## Testing Plan
Outline the comprehensive plan to test the product, ensuring all functionalities meet the quality standards. This includes defining the testing strategies, tools, and environments required to validate the product.

### Test Strategies
- Define the types of tests to be conducted: unit, integration, system, and acceptance tests.
- Explain the rationale behind selecting specific testing methodologies.
- Discuss any specific scenarios or edge cases.

### Testing Tools
- List the tools and frameworks that will be used.
- Justify the choice of these tools considering the project needs.
- Include any automation tools for continuous testing.

### Testing Environments
- Describe the environments in which tests will be conducted: development, staging, and production.
- Explain the setup and configuration of these environments.
- Mention any considerations for scalability and performance testing.

### Test Cases
- Provide examples of critical test cases to be executed.
- Describe the expected outcomes for these test cases.
- Discuss how these cases cover key functionalities and user journeys.

### Reporting and Metrics
- Define the metrics that will be tracked during testing.
- Explain how test results will be reported to stakeholders.
- Mention any tools or dashboards used for reporting.

---

## Deployment Plan
Detail the steps and considerations to deploy the product or feature seamlessly. Address the deployment environment, tools, and the specific actions required to ensure a smooth transition to production.

### Deployment Environment
- Describe the target deployment environment(s).
- Specify any requirements for infrastructure or configurations.
- Discuss considerations for high availability and disaster recovery.

### Deployment Tools
- List the tools and platforms used for deployment.
- Justify the choice of these tools, considering the project demands.
- Include any continuous integration/continuous deployment (CI/CD) pipelines.

### Deployment Steps
- Provide a step-by-step guide for the deployment process.
- Highlight important checkpoints and validation steps.
- Discuss any rollback strategies or contingency plans.

### Post-Deployment Verification
- Outline the verification process post-deployment.
- Describe the critical checks to ensure the deployment is successful.
- Mention any monitoring or alerting mechanisms.

### Continuous Deployment
- Describe the approach to continuous deployment if applicable.
- Discuss the automation tools and scripts used.
- Highlight the benefits and any specific requirements.

---
