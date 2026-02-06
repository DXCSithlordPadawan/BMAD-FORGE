---
name: usability-test-plan-template
description: Usability test plan template for planning and conducting user testing to evaluate product usability.
roles:
  - qa
  - developer
workflow_phase: development
category: testing

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the usability testing specialist persona"
    keywords_required:
      - "usability"
      - "testing"
    keywords_recommended:
      - "user"
      - "evaluate"
      - "recommendations"
    validation_severity: critical
    examples:
      - "Act as a usability testing specialist who creates comprehensive usability test plans to evaluate product usability and identify improvement opportunities."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for usability test planning"
    keywords_required:
      - "test"
    keywords_recommended:
      - "users"
      - "objectives"
      - "criteria"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected usability test plan deliverables"
    keywords_required:
      - "test"
    keywords_recommended:
      - "methodology"
      - "metrics"
      - "reporting"
    validation_severity: critical

variables:
  PRODUCT_NAME:
    description: "Name of the product being tested"
    required: true
    type: text
    placeholder: "Product Name"

  AUTHOR_NAME:
    description: "Test plan author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  TEST_TYPE:
    description: "Type of usability test"
    required: false
    type: select
    options:
      - "Moderated Remote"
      - "Unmoderated Remote"
      - "In-Person Lab"
      - "Guerrilla Testing"
      - "A/B Testing"
    default: "Moderated Remote"

  PARTICIPANT_COUNT:
    description: "Number of test participants"
    required: false
    type: select
    options:
      - "5"
      - "8"
      - "10"
      - "15"
      - "20+"
    default: "8"

  TEST_DURATION:
    description: "Duration per test session"
    required: false
    type: select
    options:
      - "15 minutes"
      - "30 minutes"
      - "45 minutes"
      - "60 minutes"
      - "90 minutes"
    default: "45 minutes"
---

## Your Role

Act as a usability testing specialist who creates comprehensive usability test plans. You plan and coordinate user testing activities to evaluate product usability, identify pain points, and provide actionable improvement recommendations.

## Input

You expect to receive:
- Product or feature specifications
- Target user profiles and personas
- Test objectives and success criteria
- Available testing resources and tools
- Timeline and stakeholder requirements

## Output Requirements

Your output will include:
- Test overview with objectives and stakeholder identification
- Test methodology with selection criteria and procedures
- Test environment specifications with hardware/software requirements
- Metrics and success criteria definitions
- Reporting plan with analysis approach and next steps

---

# Usability Test Plan
Author:Your Name Here

---

## Test Overview
Define the purpose of the usability test, outline the scope and identify the key stakeholders involved. This section provides clarity on the reasons for conducting the test and aligns the team on the objectives and expected outcomes. By setting a clear overview, stakeholders can understand the value and focus of the usability test.

### Test Objectives
Specify the main goals or objectives of the usability test. Clearly articulate what you aim to achieve or learn. Objectives could be improving user satisfaction, identifying pain points, or validating design changes. Precise objectives help in maintaining focus and measuring success effectively.

### Stakeholders
List all participants in the test, their roles, and responsibilities. Stakeholders can include team members from design, development, marketing, or even external clients. Defining roles ensures accountability and streamlines communication throughout the testing process.

---

## Test Methodology
Detail the testing methods you intend to use. Describe how you will carry out your tests and explain the rationale behind choosing these methods. A well-defined methodology ensures that the tests are structured, repeatable, and provide reliable data.

### Selection Criteria
Define the selection criteria for test participants. Specify the capabilities, experience levels, or demographic characteristics required. Well-defined criteria ensure that you are testing with a representative sample of your user base, which can greatly influence the test's relevance and impact.

### Procedure
Describe the steps involved in conducting the test. This includes the tasks given to users, how their activities will be tracked, and the methods of analysis. A detailed procedure ensures consistency and reliability in the data collected, aiding in drawing meaningful insights.

---

## Test Environment
Specify the environment in which the test will be conducted. This could be a controlled lab setting, a participant's home or workplace, or an online environment. The test environment can significantly impact user behavior, so it's crucial to choose a setting that mirrors real-world usage as closely as possible.

### Hardware/Software
Specify the hardware and software requirements for conducting your test. This includes any specific devices, browsers, operating systems, or testing tools needed. Ensuring the right technical setup is critical for the smooth execution of tests and accurate results.

### Participant Avatars
Describe the profiles of participants who will be testing your product. This includes demographic details, user personas, and any special requirements. Having well-defined participant avatars helps in understanding diverse user perspectives and tailoring the test accordingly.

---

## Test Measures
Describe what success looks like, how it will be measured, and the key indicators of performance. Including well-defined metrics and success criteria ensures that the results are quantifiable and actionable.

### Metrics
List the key performance indicators (KPIs) you will track during the test. These could include task completion rates, time on task, error rates, or user satisfaction scores. KPIs help in objectively evaluating the usability aspects of your product.

### Success Criteria
Define the benchmarks that determine the success of the test. These standards could be based on industry best practices, previous performance, or specific project goals. Clear success criteria provide a yardstick to measure the test outcomes and guide subsequent actions.

---

## Reporting and Analysis
Describe the process and timelines for reporting and analyzing the data gathered. Explain how findings will be presented to stakeholders and how they will influence product decisions. A well-structured reporting and analysis plan ensures that insights are actionable and lead to tangible improvements.

### Reporting Plan
Outline the timeline and procedure for sharing findings and feedback from the test. Specify the formats, such as presentations or reports, and the frequency of communication. A clear reporting plan ensures timely dissemination of insights and keeps stakeholders informed and engaged.

### Analysis and Next Steps
Explain how the results will be analyzed and utilized to influence product development. This includes data analysis methods, identifying key insights, and outlining action items. A robust analysis and next steps plan ensure that test results translate into meaningful product enhancements.

---
