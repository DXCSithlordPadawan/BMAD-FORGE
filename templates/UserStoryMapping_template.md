---
name: user-story-mapping-template
description: User story mapping template for organizing user stories into a visual representation of the user journey.
roles:
  - pm
  - scrum_master
workflow_phase: planning
category: agile

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the product planning specialist persona for story mapping"
    keywords_required:
      - "story"
    keywords_recommended:
      - "user"
      - "journey"
      - "prioritization"
    validation_severity: critical
    examples:
      - "Act as a product planning specialist who creates comprehensive user story maps organizing stories into visual representations of the user journey."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for user story mapping"
    keywords_required:
      - "stories"
    keywords_recommended:
      - "vision"
      - "users"
      - "requirements"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected story map deliverables"
    keywords_required:
      - "stories"
    keywords_recommended:
      - "activities"
      - "tasks"
      - "prioritized"
    validation_severity: critical

variables:
  PRODUCT_NAME:
    description: "Name of the product"
    required: true
    type: text
    placeholder: "Product Name"

  AUTHOR_NAME:
    description: "Document author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  RELEASE_TARGET:
    description: "Target release for the story map"
    required: false
    type: text
    placeholder: "Release 1.0"

  STORY_FORMAT:
    description: "User story format preference"
    required: false
    type: select
    options:
      - "As a... I want... So that..."
      - "Given... When... Then..."
      - "Job Story Format"
      - "Custom"
    default: "As a... I want... So that..."

  PRIORITIZATION_METHOD:
    description: "Story prioritization method"
    required: false
    type: select
    options:
      - "MoSCoW"
      - "RICE"
      - "Value vs Effort"
      - "Kano Model"
      - "Custom"
    default: "MoSCoW"
---

## Your Role

Act as a product planning specialist who creates comprehensive user story maps. You organize user stories into visual representations of the user journey to facilitate product development planning and prioritization.

## Input

You expect to receive:
- Product vision and user goals
- User research and persona information
- Feature requirements and constraints
- Business priorities and release timelines
- Technical dependencies and limitations

## Output Requirements

Your output will include:
- User activities representing major user goals
- Detailed user tasks under each activity
- Narrative user stories capturing desired features
- Prioritized story categorization for releases
- Balanced prioritization considering user needs and business goals

---

# User Story Mapping
Author:Your Name Here

---

## User Activities
List all the significant interactions or activities that the user is likely to engage in while using your product or service. This section sets the foundation for your user story map by outlining the complete journey of a user from start to finish. These activities represent the broader goals that the user seeks to achieve.

### Identify Common User Activities
Identify and list commonly recurring activities that users perform. This helps in understanding the user flow and perspective, providing a comprehensive view of user behavior.

### Frame the User’s Narrative
Create a detailed narrative that illustrates the user's journey from start to finish. This narrative helps aligning the user story map with the user’s needs, making the product more user-centric.

---

## User Tasks
For each User Activity, compile a detailed list of individual tasks that a user might undertake. These tasks constitute the practical steps needed to complete each User Activity, aiding in the realization of the overall user goals.

### Delineate Specific Tasks
Define and list the specific tasks that users perform under each activity. This facilitates a more granular breakdown and better understanding of each User Activity.

### Prioritize Tasks
Rank tasks based on their relevance and impact on the main User Activity. Focusing on vital tasks will guide the development process towards enhancing user satisfaction.

---

## User Stories
Create detailed, narrative-style user stories under each User Task. These stories encapsulate the various functionalities and features that users would expect to use to accomplish the User Tasks.

### Capture Desirable Features
Write user stories to highlight the desired features and functions of your product from the user's perspective. These stories are crucial for designing a user-centered product.

### Analyze User Needs and Constraints
Leverage your user stories to identify customer needs, pain points, and constraints. This analysis will steer your product development and feature prioritization.

---

## Prioritize
Create rows beneath the User Stories to represent different product releases or iterations. Assign each user story to an appropriate release row based on its importance, dependencies, and alignment with your product's strategic roadmap.

### Categorize User Stories
Sort user stories according to their relevance to the upcoming product release or iteration. This helps in setting clear objectives for each phase of development.

### Strike a Balance
Devise a strategy to balance user needs, business goals, and technical constraints when prioritizing user stories for various releases.

---
