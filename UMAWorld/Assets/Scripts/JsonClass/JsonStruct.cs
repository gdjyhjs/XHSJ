using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UMAWorld {
    public struct Point2 : IEquatable<Point2> {
        public static Point2 zero = new Point2(0, 0);
        public float x, y;

        public Point2(float x, float y) {
            this.x = x;
            this.y = y;
        }

        public bool Equals(Point2 other) {
            return other.x == x && other.y == y;
        }

        public override bool Equals(object obj) {
            if (obj is Point2) {
                Point2 other = (Point2)obj;
                return other.x == x && other.y == y;
            }
            return false;
        }

        public override int GetHashCode() {
            var hashCode = 1502939027;
            hashCode = hashCode * -1521134295 + x.GetHashCode();
            hashCode = hashCode * -1521134295 + y.GetHashCode();
            return hashCode;
        }

        public static float Distance(Point2 a, Point2 b) {
            return Vector2.Distance(new Vector2(a.x, a.y), new Vector2(b.x, b.y));
        }

        public static Point2 operator +(Point2 a, Point2 b) {
            var c = new Vector2(a.x, a.y) + new Vector2(b.x, b.y);
            return new Point2(c.x, c.y);
        }

        public static Point2 operator -(Point2 a, Point2 b) {
            var c = new Vector2(a.x, a.y) - new Vector2(b.x, b.y);
            return new Point2(c.x, c.y);
        }

        public static Point2 operator *(Point2 a, Point2 b) {
            var c = new Vector2(a.x, a.y) * new Vector2(b.x, b.y);
            return new Point2(c.x, c.y);
        }

        public static Point2 operator *(float a, Point2 b) {
            var c = a * new Vector2(b.x, b.y);
            return new Point2(c.x, c.y);
        }

        public static Point2 operator *(Point2 a, float b) {
            var c = new Vector2(a.x, a.y) * b;
            return new Point2(c.x, c.y);
        }

        public static Point2 operator /(Point2 a, float b) {
            var c = new Vector2(a.x, a.y) / b;
            return new Point2(c.x, c.y);
        }

        public static Point2 operator /(Point2 a, Point2 b) {
            var c = new Vector2(a.x, a.y) / new Vector2(b.x, b.y);
            return new Point2(c.x, c.y);
        }

        public static bool operator ==(Point2 lhs, Point2 rhs) {
            return lhs.Equals(rhs);
        }

        public static bool operator !=(Point2 lhs, Point2 rhs) {
            return !lhs.Equals(rhs);
        }
    }
}