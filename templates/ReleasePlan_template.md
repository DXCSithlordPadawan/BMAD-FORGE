---
name: release-plan-template
description: Release plan template for coordinating product releases, timelines, and go-to-market activities.
roles:
  - scrum_master
  - pm
workflow_phase: planning
category: agile

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the release manager persona for release coordination"
    keywords_required:
      - "release"
    keywords_recommended:
      - "coordinate"
      - "timelines"
      - "stakeholders"
    validation_severity: critical
    examples:
      - "Act as a release manager who creates comprehensive release planning documentation coordinating timelines and go-to-market activities."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for release planning"
    keywords_required:
      - "release"
    keywords_recommended:
      - "specifications"
      - "objectives"
      - "stakeholders"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected release plan deliverables"
    keywords_required:
      - "release"
    keywords_recommended:
      - "timeline"
      - "milestones"
      - "scope"
    validation_severity: critical

variables:
  PRODUCT_NAME:
    description: "Name of the product"
    required: true
    type: text
    placeholder: "Product Name"

  RELEASE_VERSION:
    description: "Release version number"
    required: true
    type: text
    validation: "^v?[0-9]+\\.[0-9]+.*$"
    placeholder: "v1.0.0"

  AUTHOR_NAME:
    description: "Document author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  RELEASE_TYPE:
    description: "Type of release"
    required: false
    type: select
    options:
      - "Major"
      - "Minor"
      - "Patch"
      - "Hotfix"
      - "Beta"
    default: "Minor"

  TARGET_DATE:
    description: "Target release date"
    required: false
    type: date
---

## Your Role

Act as a release manager who creates comprehensive release planning documentation. You coordinate product releases, define timelines, manage stakeholder responsibilities, and ensure successful go-to-market activities.

## Input

You expect to receive:
- Product or feature specifications
- Release objectives and success criteria
- Stakeholder information and responsibilities
- Resource availability and constraints
- Risk factors and dependencies

## Output Requirements

Your output will include:
- Product overview with target audience and value proposition
- SMART release objectives with metrics
- Complete release scope with included/excluded features
- Stakeholder responsibilities with RACI matrix
- Timeline, milestones, resource allocation, and risk mitigation plans

---

# Release Plan
Author:Your Name Here

---

## Product Overview
Summarize the product or feature being released. Discuss its main functionality, target audience, value proposition, and relationship to broader business and product strategy.

### Main Functionality
- Describe the core functionalities and features of the product or feature.
- Highlight any unique or innovative aspects.

### Target Audience
- Identify the primary users or customer segments.
- Discuss why this audience was chosen and how the product meets their needs.

### Value Proposition
- Define the key benefits and value this product brings to users.
- Explain how it differentiates from competitors.

### Strategic Alignment
- Outline how this release supports broader business and product objectives.
- Include any relevant market trends or business drivers.

---

## Release Objectives
Detail the primary goals for the release. Each objective should be Specific, Measurable, Achievable, Relevant and Time-bound (SMART).

### Specific Goals
- Clearly state the specific goals for the release.
- Ensure they are well-defined and understood by all stakeholders.

### Metrics for Measurement
- Identify metrics or KPIs that will measure the success of each objective.
- Make sure these metrics are quantifiable and trackable.

### Achievability
- Evaluate if the goals are realistic given the time and resources available.
- Adjust objectives if necessary to ensure feasibility.

### Relevance to Strategy
- Ensure each goal aligns with the broader business and product strategies.
- Include stakeholder feedback to validate relevance.

### Timeline for Completion
- Define a clear timeline for achieving each objective.
- Incorporate deadlines and intermediate milestones.

---

## Release Scope
Outline what is included in and excluded from the release, detailing key features or improvements, bug fixes, non-functional requirements, and so on.

### Included Features
- List all key features and improvements included in the release.
- Provide a brief description and purpose of each.

### Excluded Features
- Identify any features or changes not included in the release.
- Explain the reasoning behind these exclusions.

### Bug Fixes
- List major bug fixes included in the release.
- Prioritize them based on impact and urgency.

### Non-Functional Requirements
- Detail any performance, security, or usability requirements.
- Ensure these are measurable and testable.

### Dependencies and Limitations
- Outline any external dependencies that might affect the release.
- Identify any known limitations of the current release.

---

## Stakeholders and Responsibilities
Identify all participating internal and external stakeholders. Define their roles, responsibilities, and communication plans.

### Internal Stakeholders
- List all internal teams involved in the release (e.g., development, QA, marketing).
- Define their roles and specific responsibilities.

### External Stakeholders
- Identify external partners or vendors participating in the release.
- Clarify their roles and responsibilities.

### RACI Matrix
- Create a RACI matrix to map out who is Responsible, Accountable, Consulted, and Informed for each task.
- Use this to ensure clarity in roles and responsibilities.

### Communication Plan
- Develop a detailed communication plan.
- Specify frequency and channels of communication with each stakeholder group.

### Escalation Path
- Define the process for escalating issues or decisions.
- Ensure all stakeholders are aware of the escalation path.

---

## Timeline and Milestones
Layout the release schedule, specifying key milestones, task dependencies, deadlines and delivery dates.

### Key Milestones
- List all significant milestones in the release process.
- Include start and end dates for each.

### Task Dependencies
- Identify dependencies between tasks.
- Outline how these dependencies will be managed.

### Deadlines and Delivery Dates
- Specify deadlines for key tasks and final delivery date.
- Ensure these are realistic and attainable.

### Progress Tracking
- Define how progress towards milestones will be tracked.
- Set up regular check-ins or status updates.

### Contingency Planning
- Prepare contingency plans for potential delays or issues.
- Include buffer time within the timeline.

---

## Resource Allocation
List the resources (people, tools, budget, etc.) required for the release and how they will be used.

### Human Resources
- Detail team members involved and their roles.
- Include any additional hiring or contractor needs.

### Tools and Technology
- List all tools and technologies required for the release.
- Ensure necessary training and access are arranged.

### Budget
- Outline the budget allocated for the release.
- Track expenditures and ensure alignment with budget.

### Capacity Planning
- Assess team capacity to handle the workload.
- Adjust plans if needed to avoid overburdening resources.

### Resource Constraints
- Identify any potential resource constraints or limitations.
- Develop strategies to mitigate these constraints.

---

## Risks and Mitigation
Identify potential risks, their impact, likelihood, and the strategies to mitigate or manage them.

### Risk Identification
- List all potential risks associated with the release.
- Categorize them by type (e.g., technical, operational, market).

### Impact Assessment
- Assess the potential impact of each risk.
- Prioritize risks based on their severity and likelihood.

### Mitigation Strategies
- Develop strategies to mitigate identified risks.
- Assign owners for implementing these strategies.

### Monitoring and Reporting
- Define how risks will be monitored throughout the release process.
- Set up regular reporting on risk status.

### Contingency Plans
- Create contingency plans for critical risks.
- Ensure backup resources or plans are in place.

---

## Measurement and Success Criteria
Define the key performance indicators (KPIs) for release success and how they will be tracked and reported.

### Defining KPIs
- Select relevant KPIs that align with release objectives.
- Ensure these KPIs are clear and measurable.

### Tracking Mechanisms
- Establish mechanisms for tracking KPIs in real-time.
- Utilize dashboards or reports for ongoing monitoring.

### Reporting Frequency
- Specify how often KPI data will be reviewed and reported.
- Ensure this frequency aligns with decision-making needs.

### Success Benchmarks
- Define benchmarks or targets for each KPI.
- Compare actual performance against these benchmarks.

### Continuous Improvement
- Use KPI data to identify areas for continuous improvement.
- Adjust processes or strategies based on KPI insights.

---