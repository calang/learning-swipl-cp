# Timetable
An exercise in creating a realistic timetable for a small school.

## Design Approach
Overall organization of the project.

- `timetable.sh`
  - Main program execution.
  - Built to work in "batch" mode, fed by the other files.
  - Once this works, different pieces could be forged to combine into a single solution to be driven through an interactive interface like, for example, a web page.
- `src`
  - `init.pl`
    - Initialization file for the Prolog environment.
    - Defines modules search path.
  - `timetable.pl`
    - Main program logic.
  - `sap_prim.pl`
    - Describes the specific requirements of the sample school timetable to be generated.
    - Written based on `timetable_base.pl`
  - `module`
    - `timetable_base.pl`
      - Basic predicates, defining timetable structure.
    - `validation.pl`
      - predicates to validate the initial requirements.
    - `constraints.pl`
      - TBD


