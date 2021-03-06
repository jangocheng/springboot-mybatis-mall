<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>校园购物平台</title>
    <link href="${cp}/css/bootstrap.min.css" rel="stylesheet">
    <link href="${cp}/css/style.css" rel="stylesheet">

    <script src="${cp}/js/jquery.min.js" type="text/javascript"></script>
    <script src="${cp}/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="${cp}/js/layer.js" type="text/javascript"></script>
    <!--[if lt IE 9]>
    <script src="${cp}/js/html5shiv.min.js"></script>
    <script src="${cp}/js/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<!--导航栏部分-->
<jsp:include page="include/header.jsp"/>

<!-- 中间内容 -->
<div class="container-fluid">
    <h1 class="title center">修改个人信息</h1>
    <br/>
    <div class="col-sm-offset-2 col-md-offest-2">
        <!-- 表单输入 -->
        <div class="form-horizontal">
            <div class="form-group">
                <label for="inputEmail" class="col-sm-2 col-md-2 control-label">用户名</label>
                <div class="col-sm-6 col-md-6">
                    <input type="text" class="form-control" id="inputUserName" placeholder="14121047" readonly>
                </div>
            </div>
            <div class="form-group">
                <label for="inputEmail" class="col-sm-2 col-md-2 control-label">邮箱</label>
                <div class="col-sm-6 col-md-6">
                    <input type="email" class="form-control" id="inputEmail" placeholder="请输入邮箱/用户名" readonly>
                </div>
            </div>
            <div class="form-group">
                <label for="inputNickname" class="col-sm-2 col-md-2 control-label">昵称</label>
                <div class="col-sm-6 col-md-6">
                    <input type="text" class="form-control" id="inputNickname" placeholder="请输入名称"/>
                </div>
            </div>
            <div class="form-group">
                <label for="inputPassword" class="col-sm-2 col-md-2 control-label">密码</label>
                <div class="col-sm-6 col-md-6">
                    <input type="password" class="form-control" id="inputPassword" placeholder="禁止输入非法字符"/>
                </div>
            </div>
            <div class="form-group">
                <label for="inputPhoneNumber" class="col-sm-2 col-md-2 control-label">手机号码</label>
                <div class="col-sm-6 col-md-6">
                    <input type="text" class="form-control" id="inputPhoneNumber" placeholder="请输入手机号"/>
                </div>
            </div>
            <div class="form-group">
                <label for="man" class="col-sm-2 col-md-2 control-label">性别</label>
                <div class="col-sm-6 col-md-6">
                    <label class="radio-inline">
                        <input type="radio" id="man" value="option1"> 男
                    </label>
                    <label class="radio-inline">
                        <input type="radio" id="woman" value="option2"> 女
                    </label>
                </div>
            </div>
            <div class="form-group">
                <label for="birthday" class="col-sm-2 col-md-2 control-label">出生日期</label>
                <div class="col-sm-6 col-md-6">
                    <input type="text" class="form-control" id="birthday" placeholder="18"/>
                </div>
            </div>
            <div class="form-group">
                <label for="postcodes" class="col-sm-2 col-md-2 control-label">邮政编码</label>
                <div class="col-sm-6 col-md-6">
                    <input type="text" class="form-control" id="postcodes" placeholder="200444"/>
                </div>
            </div>
            <div class="form-group">
                <label for="address" class="col-sm-2 col-md-2 control-label">地址</label>
                <div class="col-sm-6 col-md-6">
                    <input type="text" class="form-control" id="address" placeholder="131xxxxxxxx"/>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-6">
                    <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="startUpdate()">确认修改</button>
                </div>
            </div>
        </div>
        <br/>
    </div>
</div>

<!--尾部-->
<jsp:include page="include/foot.jsp"/>
<script type="text/javascript">
    initData();
    function initData() {
        var userId = ${currentUser.id};
        var user = getUserById(userId);
        var userDetail = getUserDetailById(userId);
        document.getElementById("inputUserName").value = user.name;
        document.getElementById("inputEmail").value = user.email;
        document.getElementById("inputNickname").value = user.nickName;
        document.getElementById("inputPassword").value = userDetail.password;
        document.getElementById("inputPhoneNumber").value = userDetail.phoneNumber;
        document.getElementById("birthday").value = userDetail.birthday;
        document.getElementById("postcodes").value = userDetail.postNumber;
        document.getElementById("address").value = userDetail.address;
        if (userDetail.sex == 0)
            document.getElementById("man").checked = true;
        else
            document.getElementById("woman").checked = true;
    }
    function startUpdate() {
        var loading = layer.load(0);
        var user = {};
        user.userName = document.getElementById("inputUserName").value;
        user.email = document.getElementById("inputEmail").value;
        user.nickName = document.getElementById("inputNickname").value;
        user.password = document.getElementById("inputPassword").value;
        user.phoneNumber = document.getElementById("inputPhoneNumber").value;
        user.birthday = document.getElementById("birthday").value;
        user.postNumber = document.getElementById("postcodes").value;
        user.address = document.getElementById("address").value;
        user.sex = 0;
        if (document.getElementById("woman").checked)
            user.sex = 1;
        if (user.userName == '') {
            layer.msg('用户名不能为空', {icon: 2});
            return;
        }
        else if (user.userName.length >= 12) {
            layer.msg('用户名长度不能超过12个字符', {icon: 2});
            return;
        }
        if (user.nickName == '') {
            layer.msg('昵称不能为空', {icon: 2});
            return;
        }
        else if (user.nickName.length >= 15) {
            layer.msg('用户名长度不能超过15个字符', {icon: 2});
            return;
        }
        else if (user.password == '') {
            layer.msg('密码不能为空', {icon: 2});
            return;
        }
        else if (user.password.length >= 20) {
            layer.msg('密码长度不能超过20个字符', {icon: 2});
            return;
        }
        $.ajax({
            async: false, //设置同步
            type: 'POST',
            url: '${cp}/mall/user_main',
            data: JSON.stringify(user),
            dataType: "json",
            contentType: 'application/json',
            success: function (result) {
                if (result) {
                    layer.close(loading);
                    layer.msg('修改成功', {icon: 1});
                    window.location.href = "${cp}/main";
                } else {
                    layer.msg('服务器异常', {icon: 2});
                }
            },
            error: function (result) {
                layer.msg('服务器异常', {icon: 2});
            }
        });

    }

    function getUserById(id) {
        var userResult = "";
        $.ajax({
            async: false, //设置同步
            type: 'GET',
            url: '${cp}/mall/user_main/'+id+'',
            dataType: 'json',
            success: function (result) {
                userResult = result;
            },
            error: function (result) {
                layer.alert('查询错误');
            }
        });
        return userResult;
    }

    function getUserDetailById(id) {
        var userDetailResult = "";
        $.ajax({
            async: false, //设置同步
            type: 'GET',
            url: '${cp}/mall/user_main/'+id+'/detail',
            dataType: 'json',
            success: function (result) {
                userDetailResult = result;
            },
            error: function (result) {
                layer.alert('查询错误');
            }
        });
        return userDetailResult;
    }
</script>
</body>
</html>