## 练习 2: 自定义编写 Rust 内核驱动模块

> 前情提要: 换成了 `fujita/linux` 仓库, 后面应该会用到.  

1. 新建 Helloworld 文件, 在 Makefile 和 Kconfig 中写入相应内容  
![](https://s2.loli.net/2023/11/18/tBcW1NSALCJvEpq.png)

2. 进入菜单, 选中刚刚新建的样例  
   
   运行
   ```bash
   make ARCH=arm64 LLVM=1 O=build menuconfig
   ```

   选中 *Print Helloworld in Rust*:  
    ![](https://s2.loli.net/2023/11/18/24TbC8EY9nGD3mq.png)

   再次编译内核:  
   ```bash
   make ARCH=arm64 LLVM=1 O=build -j16
   ```

   > 我没有在文件夹下找到 `.ko` 文件, 只有 `.o`😰  
   > 重新打包文件系统的工作都省了

3. 进入系统, 查看结果
   
   可以看到, 自定义模块已经加载并输出了预期内容.  
   ![](https://s2.loli.net/2023/11/19/BUw9cXYQrLVTfze.png)
   > 看样子是直接编译进内核里了?  