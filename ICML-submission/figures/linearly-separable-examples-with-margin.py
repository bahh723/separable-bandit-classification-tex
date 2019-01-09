#!/usr/bin/env python3

import math
import random

NUMBER_CLASSES = 3
NUMBER_EXAMPLES_PER_CLASS = 300
RADIUS = 4.8
MINIMUM_MARGIN = 0.5
MINIMUM_DISTANCE = 0.7


def print_points(points):
    points.sort()
    for angle, radius in points:
        print("({:.2f}:{:.2f}) circle (2pt)".format(angle, radius))


def distance(p, q):
    p_angle, p_radius = p
    px = p_radius * math.cos(math.radians(p_angle))
    py = p_radius * math.sin(math.radians(p_angle))

    q_angle, q_radius = q
    qx = q_radius * math.cos(math.radians(q_angle))
    qy = q_radius * math.sin(math.radians(q_angle))

    dx = px - qx
    dy = py - qy
    return math.sqrt(dx * dx + dy * dy)


def remove_close_points(points):
    filtered = set()
    for p in points:
        is_close = False
        for q in filtered:
            if distance(p, q) < MINIMUM_DISTANCE:
                is_close = True
                break
        if not is_close:
            filtered.add(p)

    return list(filtered)


def margin(point, normal_angle):
    normal_x = math.cos(math.radians(normal_angle))
    normal_y = math.sin(math.radians(normal_angle))

    angle, radius = point
    x = radius * math.cos(math.radians(angle))
    y = radius * math.sin(math.radians(angle))

    margin = (x * normal_x) + (y * normal_y)
    return margin


def main():
    for j in range(NUMBER_CLASSES):
        begin_angle = 360.0 * j / NUMBER_CLASSES
        end_angle = 360.0 * (j + 1) / NUMBER_CLASSES
        print("% Class {} points. Angles between {} and {}".format(j, begin_angle, end_angle))
        points = []
        for i in range(NUMBER_EXAMPLES_PER_CLASS):
            angle = random.uniform(begin_angle, end_angle)
            radius = random.uniform(0, RADIUS)
            point = (angle, radius)
            if (margin(point, begin_angle + 90.0) > MINIMUM_MARGIN) and (margin(point, end_angle + 90.0) < - MINIMUM_MARGIN):
                points.append(point)
        points = remove_close_points(points)
        print_points(points)
        print("\n\n")


if __name__ == "__main__":
    random.seed(47)
    main()
