---
title: Sequence, interceptor and middleware
description: 
date: 2022-06-20
people:
- Le Hoang Anh <lehoanganh.le2001@gmail.com>
categories:
- Core concepts
tags:
- 
---



# Sequence

### 1. What is a sequence?
- A sequence is a series of steps how a specific type of server responses to incoming requests.

### 2. Common sequence for REST server in LoopBack 4

<p>
    <img 
      src="https://user-images.githubusercontent.com/62140372/174731637-4582d229-e66b-42b6-8448-f566e7a84789.png" 
      alt="A simple sequence"
      width="250"
     />
    <br>
    <em>Figure 1. A simple sequence</em>
</p>

<p>
    <img 
      src="https://user-images.githubusercontent.com/62140372/174725030-c6fc42eb-1028-415c-b86d-5149bb037a8a.png" 
      alt="A fully sequence"
      width="650"
     />
    <br>
    <em>Figure 2. A fully sequence</em>
</p>

- As you can see, `authentication` and `parse params` steps can be swapped. 
  - If you need to authenticate request, you should parse request before authenticating.
  - If you do not need to authenticate request, you can execute `authentication` step before parsing params.
- Request-preprocessing middleware is used to implement CORS, Body-parser,... In addition, it is used as error handling middleware.



# Interceptor
- Interceptors are reusable functions to add some logic around method invocations. There are many use cases for interceptors:
  - Add extra logic before/after method invocation.
  - Authorize user's access right.
  - Validate/transforms arguments or return values.
  - Visit [here](https://loopback.io/doc/en/lb4/Interceptor.html#overview) for more detail.

- Classes, provider classes and functions are implemented as interceptors will have two parameters:
  - context: [invocation context](https://loopback.io/doc/en/lb4/Interceptor.html#invocation-context).
  - next: a function to invoke next interceptor or the target method. It returns a value or promise depending on whether downstream interceptors and the target method are synchronous or asynchronous.
  - You can learn more at [here](https://loopback.io/doc/en/lb4/Interceptor.html#interceptor-functions).

- Global interceptor: apply for all method invocations (automatically invoke at the pre-processing invocation phase).
  - AuthorizationInterceptor is a global interceptor.
  - How to declare an interceptor? 
    - Step 1: Declare a class or a provider class.
    - Step 2: Decorate it with `@injectable()` decorator and pass `asGlobalInterceptor()`.
        ```
        @injectable(asGlobalInterceptor())
        class TestGlobalInterceptor {
          constructor() {}
        }
        ```
    - Step 3: Using `toInjectable()` to bind it into the context.
    - Note: If you do not use `@injectable` decorator, you can implement using binding's method `apply()` and `asGlobalInterceptor()`.
      ```
      context
        .bind('globalInterceptors.MetricsInterceptor')
        .toProvider(MetricsInterceptorProvider)
        .apply(asGlobalInterceptor('metrics'));
      ```

- Local interceptor: apply for some specific method invocations.
  - An interceptor decorator also uses as class-level interceptor and method-level interceptor.
  - Class-level interceptor is apply for all class's methods.
  - Method-level interceptor is apply for a specific class's method (include static method).
  - You can use multiple interceptors for a class or a method.
  - Order of interceptor executions is explained through an example below:
    ```
    @intercept(log)
    class MyController {
    
      @intercept(log1)
      @intercept(log2)
      greetSync(name: string) {
        return `Hello, ${name}`;
      }
    }
    ```
    - List of interceptors to apply: [log, log1, log2].
    - The list of interceptors is created from top to bottom and from left to right. The duplicate interceptors are removed from their first occurrences.
      ```
      @intercept(log)
      class MyController {
      
        @intercept(log1)
        @intercept(log)
        greetSync(name: string) {
          return `Hello, ${name}`;
        }
      }
      // list of interceptors: [log1, log]
      ```



# Middleware



# References
- [Sequence](https://loopback.io/doc/en/lb4/Sequence.html)
- [Interceptor](https://loopback.io/doc/en/lb4/Interceptor.html)
