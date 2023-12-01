import java.lang.reflect.Field;
import java.lang.reflect.Method;

import javassist.*;

public class DynamicClassCreation {

    public static void main(String[] args) {
        try {
            // Create a new class
            ClassPool classPool = ClassPool.getDefault();
            CtClass dynamicClass = classPool.makeClass("DynamicClass");

            // Add an attribute (field) to the class
            CtField field = new CtField(CtClass.intType, "dynamicField", dynamicClass);
            dynamicClass.addField(field);

            // Add a method to the class
            CtMethod method = CtNewMethod.make("public void dynamicMethod() { System.out.println(\"Dynamic method called!\"); }", dynamicClass);
            dynamicClass.addMethod(method);

            // Create an instance of the dynamic class using reflection
            Class<?> generatedClass = dynamicClass.toClass();
            Object dynamicObject = generatedClass.getDeclaredConstructor().newInstance();

            // Set accessibility to true for the field
            Field dynamicField = generatedClass.getDeclaredField("dynamicField");
            dynamicField.setAccessible(true);

            // Access and modify the field
            dynamicField.set(dynamicObject, 42);
            System.out.println("Dynamic field value: " + dynamicField.get(dynamicObject));

            // Call the dynamic method using reflection
            Method dynamicMethod = generatedClass.getDeclaredMethod("dynamicMethod");
            dynamicMethod.invoke(dynamicObject);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
