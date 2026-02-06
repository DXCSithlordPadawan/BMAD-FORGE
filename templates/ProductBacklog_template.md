---
name: product-backlog-template
description: Product backlog template for managing prioritized list of features, user stories, and tasks.
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
    help_text: "Define the product owner or scrum master persona for backlog management"
    keywords_required:
      - "backlog"
    keywords_recommended:
      - "prioritize"
      - "stories"
      - "agile"
    validation_severity: critical
    examples:
      - "Act as a product owner who creates and maintains comprehensive product backlogs, organizing and prioritizing features and user stories."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for backlog creation"
    keywords_required:
      - "stories"
    keywords_recommended:
      - "priorities"
      - "requirements"
      - "feedback"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected backlog deliverables"
    keywords_required:
      - "stories"
      - "prioritized"
    keywords_recommended:
      - "criteria"
      - "goals"
    validation_severity: critical

variables:
  PRODUCT_NAME:
    description: "Name of the product"
    required: true
    type: text
    placeholder: "Product Name"

  AUTHOR_NAME:
    description: "Backlog owner name"
    required: true
    type: text
    placeholder: "Your Name Here"

  SPRINT_LENGTH:
    description: "Sprint duration"
    required: false
    type: select
    options:
      - "1 week"
      - "2 weeks"
      - "3 weeks"
      - "4 weeks"
    default: "2 weeks"

  METHODOLOGY:
    description: "Agile methodology used"
    required: false
    type: select
    options:
      - "Scrum"
      - "Kanban"
      - "Scrumban"
      - "XP"
    default: "Scrum"
---

## Your Role

Act as a product owner or scrum master who creates and maintains comprehensive product backlogs. You organize, prioritize, and document features, user stories, and tasks to guide agile development and ensure alignment with product vision.

## Input

You expect to receive:
- Product vision and strategic goals
- User stories and feature requirements
- Stakeholder priorities and feedback
- Technical constraints and dependencies
- Sprint capacity and timeline information

## Output Requirements

Your output will include:
- Product vision and strategic alignment documentation
- SMART product goals with time-bound targets
- Prioritized user stories with acceptance criteria
- Backlog priority ranking with ROI evaluation
- Resource allocation and strategic impact assessment

---

# Product Backlog
Author:Your Name Here

---

## Product Vision
This section sets the direction for your product by clearly defining its ultimate aim. It describes the value the product will deliver to customers and its alignment with the company's strategic goals and broader mission. A compelling vision serves as a guiding star, ensuring the team remains focused and aligned.

### Vision Statement
- Compose a concise and motivational vision statement.
- Focus on customer-centric and outcome-driven results.
- Highlight unique differentiators from competitors.

### Strategic Alignment
- Illustrate alignment between the product vision and overall company strategy.
- Emphasize key objectives the product seeks to achieve.
- Maintain consistency with the company’s mission and core values.

---

## Product Goals
Articulate the primary goals that drive the realization of the product vision. Goals should be SMART (Specific, Measurable, Achievable, Relevant, and Time-bound) to facilitate clear understanding and effective tracking. These goals are essential in guiding the development process and optimizing prioritization.

### Goal Definition
- Articulate goals with clarity and precision.
- Define measurable endpoints and KPIs.
- Ensure goals are realistic given the available resources.

### Relevance and Alignment
- Validate goals against broader business objectives.
- Align goals with market needs and customer expectations.
- Ensure goals contribute to strategic long-term success.

### Time-bound Targets
- Set achievable deadlines for each goal.
- Establish a timeline to track progress and milestones.
- Regularly review deadlines and adjust as necessary.

---

## Features/Items
This section offers an overview of the key features of the product, including scope and estimated completion times. Prioritize these features in alignment with product goals and customer demands to ensure stakeholders understand essential functionalities and their significance.

### User Stories
- Craft user stories that clearly describe the user, their needs, and rationale.
- Ensure stories are succinct and outcome-focused.
- Prioritize user stories based on impact and business value.

### Acceptance Criteria
- Define clear conditions for feature acceptance.
- Use tangible, testable criteria linked to user stories.
- Ensure all stakeholders agree on the criteria.

### Prioritization
- Rank features by value and effort required.
- Continuously reassess priorities as business needs evolve.
- Strike a balance between quick wins and long-term value.

---

## Backlog Priority
Organize backlog items based on their ROI to ensure the most valuable tasks are addressed first. High-priority items should closely align with strategic objectives and customer needs for optimal resource use.

### Ranking Criteria
- Evaluate ROI for each backlog item.
- Incorporate both quantitative and qualitative measures.
- Maintain a consistent ranking methodology.

### Strategic Impact
- Align high-priority items with strategic objectives.
- Assess the contribution of each item to overall success.
- Adapt prioritization based on market conditions and feedback.

### Resource Allocation
- Distribute resources according to item priority.
- Ensure critical items receive necessary focus.
- Manage balance between effort and anticipated outcomes.

---
