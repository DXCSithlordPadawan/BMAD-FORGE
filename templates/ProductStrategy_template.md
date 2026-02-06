---
name: product-strategy-template
description: Product strategy template for defining vision, mission, market analysis, OKRs, and strategic approaches.
roles:
  - pm
  - architect
workflow_phase: planning
category: product-management

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the product strategist persona for strategy documentation"
    keywords_required:
      - "strategy"
    keywords_recommended:
      - "vision"
      - "market"
      - "OKRs"
    validation_severity: critical
    examples:
      - "Act as a product strategist who creates comprehensive product strategy documentation including vision, market analysis, and OKRs."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for strategy development"
    keywords_required:
      - "product"
    keywords_recommended:
      - "market"
      - "competitors"
      - "objectives"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected strategy document deliverables"
    keywords_required:
      - "strategy"
    keywords_recommended:
      - "vision"
      - "OKRs"
      - "roadmap"
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

  STRATEGY_HORIZON:
    description: "Strategy time horizon"
    required: false
    type: select
    options:
      - "1 year"
      - "2 years"
      - "3 years"
      - "5 years"
    default: "3 years"

  MARKET_SEGMENT:
    description: "Primary market segment"
    required: false
    type: select
    options:
      - "Enterprise"
      - "Mid-Market"
      - "SMB"
      - "Consumer"
      - "Developer"
    default: "Enterprise"
---

## Your Role

Act as a product strategist who creates comprehensive product strategy documentation. You define product vision, mission, market analysis, OKRs, and strategic approaches to guide product development and market positioning.

## Input

You expect to receive:
- Product concept and value proposition
- Market research and industry analysis
- Competitor information and positioning
- Business objectives and success metrics
- Resource constraints and capabilities

## Output Requirements

Your output will include:
- Product vision and mission statements
- Market analysis with industry trends and competitor evaluation
- Objectives and Key Results (OKRs) with measurable outcomes
- Product development, marketing, and customer success strategies
- Product roadmap with risk assessment and mitigation plans

---

# Product Strategy
Author:Your Name Here

---

## Product Vision and Mission
Define the overarching purpose and long-term impact of your product. Your Product Vision and Mission steer your strategy, providing focus and meaning.

### Product Vision
Articulate the future state or ultimate aspiration of your product. It should be compelling and align with your company’s broader vision.

### Product Mission
Convey what your product aims to achieve for its users and how it contributes to realizing your Product Vision.

---

## Market Analysis
Gain a deep understanding of your market landscape. Identify industry trends, evaluate competitors, analyze your target audience, and pinpoint opportunities and threats.

### Industry Trends
Identify and assess current and emerging trends that could influence your product and business.

### Competitor Analysis
Evaluate your competitors’ strengths, weaknesses, opportunities, and threats (SWOT) comprehensively.

### Target Audience Analysis
Profile your target audience: Understand their needs, behaviors, aspirations, and pain points.

---

## Objectives and Key Results (OKRs)
Set precise, measurable, and attainable objectives for your product. Define key results to monitor progress and success in achieving these objectives.

### Objectives
Define the high-level objectives for your product. Ensure they are specific, time-bound, and aligned with your Product Vision and broader company goals.

### Key Results
Establish measurable outcomes that demonstrate achievement of your objectives. They should be quantifiable, realistic, and facilitate objective assessment.

---

## Product Strategies
Craft strategic approaches in critical areas such as product development, marketing, sales, and customer success. These strategies should support your efforts in meeting the set Objectives.

### Product Development Strategy
Detail your approach to improving and evolving your product. Discuss plans for feature development, UX/UI enhancements, and technical upgrades.

### Marketing and Sales Strategy
Outline your approach to promoting your product and driving sales. Include positioning strategies, marketing campaigns, sales tactics, etc.

### Customer Success Strategy
Describe your plan to ensure customer satisfaction and loyalty. Discuss support, education, retention, and upsell strategies.

---

## Product Roadmap
Create a detailed, time-specific plan outlining your product’s trajectory. Include new features, enhancements, key milestones, and timelines.

### Feature Development
Outline planned new features and improvements.

### Milestones
Identify significant milestones in your product’s journey.

### Timeline
Establish the timeframe for achieving these milestones and releasing features.

---

## Risk Assessment and Mitigation
Identify potential challenges and risks that could impact your product strategy. Develop proactive mitigation strategies to address these risks and ensure strategic resilience.

### Potential Risks
Enumerate foreseeable challenges that could impede progress or disrupt your strategy. Consider market, technical, financial, operational, and competitive risks to provide a comprehensive overview.

### Mitigation Strategies
Detail the proactive steps you will take to lessen the impact of potential risks. Ensure these strategies are well-thought-out and address the specific risks identified.

### Contingency Plans
Develop clear contingency plans for high-risk areas. Specify alternative actions or adjustments should the initial strategy encounter issues, ensuring minimal disruption.

### Risk Monitoring
Establish a continuous process for monitoring risks throughout the strategy execution. Regular reviews and updates of risk assessments ensure they remain relevant and effective.

---

