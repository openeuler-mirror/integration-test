# integration-test

## Description
This repository stores source code for integration and smoke test capabilities of openEuler.

## Software Architecture

├── README.md  
├── License  
│   └── LICENSE  
├── suite2cases  
└── testcases  

## Instructions
The test code stored in this repository is compiled based on the [mugen](https://gitee.com/openeuler/test-tools.git) framework. To use the test capability, perform the following steps:

- Download the [mugen](https://gitee.com/openeuler/test-tools.git) test framework.
- Download the test code in the repository and save it to the corresponding directory of the test framework.
- Perform the test according to the [mugen User Guide](https://gitee.com/openeuler/test-tools/blob/master/mugen/README.md).

## Contribution
1. Fork this repository.
2. Define the mapping between test suites and test cases in the specified file in the **suite2cases** directory.
3. Compile test code and save it to the **testcases** directory by referring to [Test Case Naming and Coding Specifications](https://gitee.com/openeuler/package-reinforce-test/blob/master/test-case-naming-and-coding-specifications.md).
4. Download the [mugen](https://gitee.com/openeuler/test-tools.git) test framework and debug the code.
5. Commit your code.
6. Create a Pull Request on Gitee.


#### Gitee Feature

1.  You can use Readme\_XXX.md to support different languages, such as Readme\_en.md, Readme\_zh.md
2.  Gitee blog [blog.gitee.com](https://blog.gitee.com)
3.  Explore open source project [https://gitee.com/explore](https://gitee.com/explore)
4.  The most valuable open source project [GVP](https://gitee.com/gvp)
5.  The manual of Gitee [https://gitee.com/help](https://gitee.com/help)
6.  The most popular members  [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
