using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class MathTools {

    public static int IntegerSqrt(int value) {
        int result = 0;
        while (result * result < value) {
            result++;
        }
        return result;
    }
}