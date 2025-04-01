# Scaffold

A structured yet breathable scheduling app. Includes a hour-based timeline and intuitive event customization.

To allow for structure and flexibility, users can add:
- Blocks
  - Blocks are duration based events, and have include toggles for Scheduled and Rigid. These two variables allow for lots of flexibility
    - Scheduled determines whether the event has a set start time. For example, a class or appointment will likely be scheduled, while a task that you just need to get done at some point won't be.
    - Rigid determines whether the event has a set duration. For example, a class likely will be rigid, while something like music practice might not be, since it could go over or under a goal duration. Rigid events might appear with solid outlines, while non-rigid events might be indicated by dotted outlines.
  - These two variables can be combined to fit most situations (set start time and duration, set start time and flexible duration, flexible start time and set duration, flexible start time and flexible duration)
- Tasks
  - Tasks are events without a duration, such as turning in an assignment. They can be scheduled or not scheduled.
 
Together, blocks and tasks cover most situations. However, events without a given start time or duration might look confusing when placed on the timeline. To solve this issue, I plan on adding a Time Groups.
- Time Groups are optional, and can be placed across any portion of the timeline. They appear as a slightly greyed out section with a border.
  - Any event may be placed into a time group. Non-scheduled events will be displayed in list format, with scheduled events appearing amongst the list at the appropriate timeline location. Additionally, duration based events will be displayed with the proportional size in the list.
- For example, you might have a set of scheduled/non-scheduled and rigid/non-rigid events to complete before class. You might create a Time Group called Morning, and add those tasks to the group. Now, scheduled or rigid events will still be structured, and the rest will still be displayed, without any confusion of start times.
