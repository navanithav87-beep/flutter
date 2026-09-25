class Dog{
  String name;
  int age;

  Dog(this.name , this.age);

  void display(){
    print('$name is $age years old');
  }
}

class Cat{
    String name;
    int age;
  
    Cat(this.name,this.age);
    
  void display(){
    print('$name  cat is $age years old');
  }
}

void main(){
  Dog d = new Dog('Jack',5);
  d.display();
  Cat c = new Cat('Keyoo',7);
  c.display();
}