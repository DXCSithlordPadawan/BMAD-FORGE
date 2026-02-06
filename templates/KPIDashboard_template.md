---
name: kpi-dashboard-template
description: KPI dashboard template for tracking and reporting key performance indicators and metrics.
roles:
  - pm
  - analyst
workflow_phase: planning
category: product-management

sections:
  "Your Role":
    required: true
    min_words: 20
    max_words: 150
    input_type: textarea
    help_text: "Define the performance analyst persona for KPI tracking"
    keywords_required:
      - "KPI"
    keywords_recommended:
      - "metrics"
      - "performance"
      - "analysis"
    validation_severity: critical
    examples:
      - "Act as a performance analyst who creates comprehensive KPI dashboard documentation tracking and analyzing key performance indicators."

  "Input":
    required: true
    min_words: 15
    input_type: textarea
    help_text: "Specify inputs needed for KPI dashboard creation"
    keywords_required:
      - "metrics"
    keywords_recommended:
      - "KPI"
      - "data"
      - "goals"
    validation_severity: critical

  "Output Requirements":
    required: true
    min_words: 20
    input_type: textarea
    help_text: "Define the expected KPI dashboard deliverables"
    keywords_required:
      - "KPI"
    keywords_recommended:
      - "analysis"
      - "trends"
      - "recommendations"
    validation_severity: critical

variables:
  DASHBOARD_NAME:
    description: "Name of the KPI dashboard"
    required: true
    type: text
    placeholder: "Dashboard Name"

  AUTHOR_NAME:
    description: "Document author name"
    required: true
    type: text
    placeholder: "Your Name Here"

  REPORTING_PERIOD:
    description: "Reporting period frequency"
    required: false
    type: select
    options:
      - "Daily"
      - "Weekly"
      - "Monthly"
      - "Quarterly"
      - "Annual"
    default: "Monthly"

  BUSINESS_UNIT:
    description: "Business unit or department"
    required: false
    type: text
    placeholder: "Business Unit"
---

## Your Role

Act as a performance analyst who creates comprehensive KPI dashboard documentation. You track, analyze, and report on key performance indicators to provide actionable insights for product improvement and strategic decision-making.

## Input

You expect to receive:
- Key metrics and KPI definitions
- Current performance data and trends
- Business goals and success criteria
- Historical data for comparison
- Stakeholder reporting requirements

## Output Requirements

Your output will include:
- Dashboard overview with key metrics summary
- Detailed KPI breakdown and trend analysis
- Identified issues, bottlenecks, and improvement areas
- Recommended action steps with prioritization
- Projected outcomes and impact estimations

---

# KPI Dashboard
Author:Your Name Here

---

## Dashboard Overview
This section provides a quick, high-level summary of the most critical metrics for your product. It should succinctly inform stakeholders about key performance indicators such as active users, revenue, and new sign-ups. This snapshot ensures that everyone is aligned on current performance.

### Key Metrics
List the primary metrics essential to your product's success. These may include Monthly Active Users (MAU), Daily Active Users (DAU), Customer Lifetime Value (CLTV), churn rate, and others pertinent to the business goals. Ensure alignment with overarching product objectives.

### Current Status
Detail the present state of these key metrics with real-time data. Include a brief commentary on trends, anomalies, and insights for each indicator, highlighting what’s going well and areas that need attention.

---

## Detailed KPI Analysis
This section delves into the specific areas of your product's performance metrics. By breaking down each KPI, you gain a better understanding of contributing factors, uncover patterns, and identify trends. Analyze data such as feature usage, user flow, and segmentation.

### KPI Breakdown
Break each KPI into its underlying components. For example, user acquisition can be segmented by referral sources, demographics, and marketing channels. This granularity helps in pinpointing what drives metric changes.

### Trends
Extract and highlight significant trends from the KPI data. Explain how product usage is evolving, how different user segments respond to new features, promotions, or changes, and any emerging behavior patterns.

---

## Areas of Improvement
Identify potential areas for enhancement based on insights from your detailed KPI analysis. Highlight features that are underperforming, segments with low engagement, or missed opportunities in user acquisition. This section should focus on data-driven improvement areas.

### Identified Issues and Bottlenecks
Narrate in detail the specific issues and bottlenecks discovered from the KPI analysis. Describe their potential impact on your product's performance, providing context and relevance to your product goals.

### Recommended Action Steps
Offer actionable steps to address each identified issue. Propose solutions backed by data, ensuring they align with overall product objectives. Each recommendation should be clear, feasible, and strategically sound.

---

## Projected Outcomes
Predict future performance improvements based on implementing your recommended actions. Project how the KPIs will evolve given the proposed changes, providing a foresight into potential achievements.

### Forecast
Provide a carefully considered projection of KPI performance if the recommended actions are executed. Leverage historical data, industry benchmarks, and predictive models for these forecasts.

### Impact Estimation
Evaluate the expected impact of projected outcomes on overall product performance and user experience. Assess alignment with product goals and quantify the potential benefits and improvements.

---
