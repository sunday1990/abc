项目组织架构

	一，项目目录
		
		Entrance：这个目录下放的是AppDelegate.h(.m)文件，是整个应用的入口文件。

		Views：这个目录下放自定义的view,cell文件夹中全是tableview的自定义cell：

		ViewController ：这个目录下放了所有的viewcontrollers


			|-TabPage 文件夹   里面放了主要的tab页

                    |- OrderViewController 订单tab页

                    |- AccountViewController 用户tab页

                    |- MapViewController 地图tab页

                    |- SystemSetViewController 系统tab页


            |-SecondDownpage 文件夹 第二级页面

                    |- OrderDetailViewController  订单详情
                    |- SystemDetailViewController 系统设置详情
                    |- AccountDetail              账户明细
                    |- withDrawViewController     提现页面
                    |- OrderListViewController    订单列表
                    |- pushOrderDetailController  推送订单的详情页面
                    |- RemedyOrderViewController  补单页面
                    |- UserInfoVc                 个人信息
                    |- SignDateResultVc           签到详情（历史订单数量详情）

             |-thirdDownPage 文件夹 第二级页面

                    |- ChooseAddressViewController            选择地址
                    |- WithDrawMoneyController                提现页面
                    |- alertOrderViewController               提示订单页面
                    |- historyOrderDetailViewController       历史订单详情
                    |- noticeDetailController                 系统通知消息
                    |- textBoardView                          textView详情页面

         LoginPage：

                    |- LoginViewController                    登陆页
         NetWork：

                    |- NetWorkTool                            网络请求类
                    |- NetworkingState                        加请求状态


		 Common ：

				|-common              通用的宏定义
                |-ConstantDefinition  通用常量宏定义
                |-UtilityMethod       常用方法宏定义
                |-NetWork             推送标识



		SysConfig：

                |-SystemConfig        系统信息本地存储的类

        ThirdPart：这个类里面是第三方使用类库。
