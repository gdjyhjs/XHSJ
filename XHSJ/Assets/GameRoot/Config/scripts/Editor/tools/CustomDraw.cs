using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomPropertyDrawer(typeof(Sprite))]
public class CustomDrawSprite : CustomDraw <Sprite>{}



public abstract class CustomDraw <T>: PropertyDrawer where T: Object {
    float height = 0;
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label) {
        T target = property.objectReferenceValue as T;
        if (target == null) {
            EditorGUI.ObjectField(position, property);
            height = 20;
        } else {
            property.objectReferenceValue = EditorGUI.ObjectField(position, label, target, typeof(T), true) as T;
            height = 60;
        }
    }

    public override float GetPropertyHeight(SerializedProperty property, GUIContent label) {
        return height;
    }
}