# Simple simulator to create a waiting list

Creates a simulated waiting list comprising referral dates, and removal
dates

## Usage

``` r
wl_simulator(
  start_date = NULL,
  end_date = NULL,
  demand = 10,
  capacity = 11,
  waiting_list = NULL,
  withdrawal_prob = NA_real_,
  detailed_sim = FALSE
)
```

## Arguments

- start_date:

  Date or character (in format 'YYYY-MM-DD'); The start date to
  calculate from

- end_date:

  Date or character (in format 'YYYY-MM-DD'); The end date to calculate
  to

- demand:

  numeric. Weekly demand (i.e., typical referrals per week).

- capacity:

  numeric. Weekly capacity (i.e., typical removals per week).

- waiting_list:

  data.frame. Waiting list where each row is a pathway/patient with date
  columns 'Referral' and 'Removal'.

- withdrawal_prob:

  numeric. Probability of a patient withdrawing.

- detailed_sim:

  logical. If TRUE, simulation provides detailed output.

## Value

A `data.frame` simulating a waiting list, with columns:  

- Referral:

  Date. The date each patient was added to the waiting list.

- Removal:

  Date. The date each patient was removed from the waiting list (may be
  `NA` if unscheduled).

  

**If `detailed_sim = TRUE`**, returns a more detailed `data.frame` with
the following additional fields:  

- Withdrawal:

  Date. The date the patient withdrew from the waiting list.

- Priority:

  Numeric. Waiting list priority level, from 1 (most urgent) to 4 (least
  urgent).

- Target_wait:

  Numeric. Target number of days the patient should wait at the assigned
  priority level (e.g., 28 days for priority 2)

- Name:

  Character. Patient name in the format `"Last, First"`.

- Birth_date:

  Date. Date of birth.

- NHS_number:

  Integer. Patient identifier, up to 100,000,000.

- Specialty_code:

  Character. One-letter code representing the specialty of the
  procedure.

- Specialty:

  Character. Full name of the specialty associated with the procedure.

- OPCS:

  Character. OPCS-4 code of the selected procedure.

- Procedure:

  Character. Name of the selected procedure.

- Consultant:

  Character. Consultant name in the format `"Last, First"`.

## Examples

``` r

over_capacity_simulation <-
  wl_simulator("2024-01-01", "2024-03-31", 100, 110)
under_capacity_simulation <-
  wl_simulator("2024-01-01", "2024-03-31", 100, 90)
```
