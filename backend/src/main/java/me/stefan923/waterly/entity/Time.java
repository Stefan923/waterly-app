package me.stefan923.waterly.entity;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Time implements Comparable<Time> {

    private int hour;
    private int minute;

    @Override
    public int compareTo(Time other) {
        if (this.hour < other.hour) {
            return -1;
        } else if (this.hour > other.hour) {
            return 1;
        } else {
            return Integer.compare(this.minute, other.minute);
        }
    }

}
