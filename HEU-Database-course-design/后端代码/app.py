# import caching as caching
from flask import Flask, jsonify, request
from sqlalchemy import text

from config import BaseConfig
from flask_sqlalchemy import SQLAlchemy
import auth
# from aliyunsms.sms_send import send_sms
import json
import random
import datetime
from redis import StrictRedis

# 创建redis对象
redis_store = StrictRedis(host=BaseConfig.REDIS_HOST, port=BaseConfig.REDIS_PORT, decode_responses=True)

# 跨域
from flask_cors import CORS
from flask_cors import cross_origin

app = Flask(__name__)

# 添加配置数据库
app.config.from_object(BaseConfig)
# 初始化拓展,app到数据库的ORM映射
db = SQLAlchemy(app)

# 检查数据库连接是否成功
with app.app_context():
    with db.engine.connect() as conn:
        rs = conn.execute(text("select 1"))
        print(rs.fetchone())



# 用户登录
@app.route("/api/user/login", methods=["POST"])
@cross_origin()
def user_login():
    print(request.json)
    userortel = request.json.get("userortel").strip()
    password = request.json.get("password").strip()
    sql = ('select * ' \
           + 'from user ' \
           + 'where telephone = "{0}" and password = "{1}"').format(userortel, password)
    data = db.session.execute(text(sql)).first()
    print(data)
    if data != None:
        user = {'id': data[0], 'username': data[1], 'password': data[2], 'telephone': data[3]}
        # 生成token
        token = auth.encode_func(user)
        print(token)
        return jsonify({"code": 200, "msg": "登录成功", "token": token, "role": data[4]})
    else:
        return jsonify({"code": 1000, "msg": "用户名或密码错误"})


# 用户注册__发送验证码
# @app.route("/api/user/register/send_sms", methods=["POST"])
# @cross_origin()
# def register_sms():
#     # print(request.json)
#     phone = request.json.get("telephone")
#     # print(str(phone))
#     # params = {'code': '756821'}  # abcd就是发发送的验证码，code就是模板中定义的变量
#     # print(params)
#     # 生成随机的6位验证码
#     num = random.randrange(100000, 999999)
#     params = {'code': 123456}
#     params['code'] = num
#
#     # 将验证码保存到redis中，第一个参数是key，第二个参数是value，第三个参数表示60秒后过期
#     redis_store.set('valid_code:{}'.format(phone), num, 600)
#     print(redis_store.get('valid_code:{}'.format(phone)))
#     # 调用send_sms函数来发送短信验证码
#     result = send_sms(str(phone), json.dumps(params))
#     print(result)
#     if result[3]:
#         return jsonify({"code": "200", "msg": "验证码发送成功"})
#     else:
#         return jsonify({"code": '1000', "msg": "验证码发送失败"})



# # 用户注册__检测验证码和手机是否在数据库中
# @app.route("/api/user/findback", methods=["POST"])
# @cross_origin()
# def findback():
#     rq = request.json
#     # 获取验证码和手机号
#     password = rq.get("password")
#     vercode = rq.get("vercode")
#     telephone = rq.get("telephone")
#
#     if vercode != redis_store.get('valid_code:{}'.format(telephone)):
#         return jsonify({"status": "1000", "msg": "验证码错误"})


# 用户注册__检测验证码和手机是否在数据库中
# @app.route("/api/user/register/test", methods=["POST"])
# @cross_origin()
# def register_test():
#     rq = request.json
#     # 获取验证码和手机号
#     username = rq.get("username")
#     password = rq.get("password")
#     vercode = rq.get("vercode")
#     telephone = rq.get("telephone")
#
#     # 先判断验证码对错
#     if vercode != redis_store.get('valid_code:{}'.format(telephone)):
#         return jsonify({"status": "1000", "msg": "验证码错误"})
#
#     data = db.session.execute(text('select * from user where telephone="%s"' % telephone)).fetchall()
#     if not data:
#         db.session.execute(text('insert into user(username,password,telephone,role) value("%s","%s","%s",0)' % (
#             username, password, telephone)))
#         db.session.commit()
#         return jsonify({"status": "200", "msg": "注册成功"})
#     else:
#         return jsonify({"status": "1000", "msg": "该用户已存在"})


# 用户界面获取店铺信息
@app.route("/api/user/shop", methods=["GET"])
@cross_origin()
def user_get_shop():
    data = db.session.execute(text('select * from fastfood_shop')).fetchall()

    Data = []
    for i in range(len(data)):
        dic = dict(shop_name=data[i][0], price=data[i][1], sale=data[i][2])
        Data.append(dic)
    print(Data)
    # return jsonify({"status":"200", "tabledata": Data})
    return jsonify(status=200, tabledata=Data)


# 下订单
@app.route("/api/user/addorder", methods=["POST"])
@cross_origin()
def user_addorder():
    rq = request.json
    # 获取各个参数
    shopname = rq.get("shop_name")
    ordermoney = rq.get("order_money")
    orderway = rq.get("order_way")
    consphone = get_token_phone(request.headers.get('token'))
    consname = rq.get("cons_name")
    consaddre = rq.get("cons_addre")
    create_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # print(shop_name, order_money, order_way, cons_phone, cons_name, cons_addre)
    db.session.execute(text( 'insert into oorder( shop_name, order_money, order_way, cons_phone, cons_name, cons_addre,create_time) value("%s", %d, "%s", "%s", "%s", "%s","%s")' % (
            shopname, ordermoney, orderway, consphone, consname, consaddre, create_time)))
    db.session.commit()
    # db.session.execute('insert into fastfood_shop(shop_name, price, m_sale_v) values("解耦哎",10,100)')
    # db.session.commit()
    return jsonify(status=200, msg="成功下单")


def get_token_phone(token):
    data = auth.decode_func(token)
    phone = data['telephone']
    return (phone)


@app.route("/api/user/unsend", methods=["POST", "GET", "DELETE"])
@cross_origin()
def user_unsend():
    if request.method == 'GET':
        phone = get_token_phone(request.headers.get('token'))
        print(phone)
        data = db.session.execute(text('select * from oorder where checked=0 and cons_phone="%s"' % phone)).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(order_id=data[i][0], shop_name=data[i][1], price=data[i][2], orderway=data[i][3],
                       cons_name=data[i][5], cons_addre=data[i][6], create_time=data[i][8])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)
    if request.method == 'POST':
        rq = request.json
        order_id = rq.get("order_id")
        cons_name = rq.get("cons_name")
        cons_addre = rq.get("cons_addre")
        print(order_id)
        db.session.execute(
            text('update oorder set cons_name="%s", cons_addre="%s" where order_id="%d"' % (cons_name, cons_addre, order_id)))
        db.session.commit()
        return jsonify(status=200, msg="修改成功")
    if request.method == 'DELETE':
        order_id = request.json.get("delete_id")
        db.session.execute(text('delete from oorder where order_id="%d" ' % order_id))
        db.session.commit()
        return jsonify(status=200, msg="删除成功")


@app.route("/api/user/sending", methods=["POST", "GET", "DELETE"])
@cross_origin()
def user_sending():
    if request.method == 'GET':
        phone = get_token_phone(request.headers.get('token'))

        data = db.session.execute(text('select * from sending_order where cons_phone="%s"' % phone)).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(order_id=data[i][0], shop_name=data[i][1], order_money=data[i][2], order_way=data[i][3],
                       cons_phone=data[i][4],
                       cons_name=data[i][5], cons_addre=data[i][6], disp_id=data[i][7], deliver_time=data[i][8],
                       disp_phone=data[i][9])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)


@app.route("/api/user/sended", methods=["POST", "GET", "DELETE"])
@cross_origin()
def user_sended():
    if request.method == 'GET':
        phone = get_token_phone(request.headers.get('token'))
        data = db.session.execute(text('select * from sended_order where cons_phone="%s"' % phone)).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(order_id=data[i][0], shop_name=data[i][1], order_money=data[i][2], order_way=data[i][3],
                       cons_phone=data[i][4],
                       cons_name=data[i][5], cons_addre=data[i][6], disp_id=data[i][7], deliver_time=data[i][8],
                       disp_phone=data[i][9])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)


@app.route("/api/user/usermsg", methods=["POST", "GET"])
@cross_origin()
def usermsg():
    if request.method == 'GET':
        phone = get_token_phone(request.headers.get('token'))
        data = db.session.execute(text('select * from user_msg where phone="%s"' % phone)).fetchall()
        Data = dict(real_name=data[0][1], sex=data[0][2], age=data[0][3], mail=data[0][4], phone=data[0][5],
                   user_name=data[0][6])

        return jsonify(status=200, data=Data)


@app.route("/api/user/pwd_chg", methods=["POST"])
@cross_origin()
def user_pwd_chg():
    if request.method=='POST':
        pwd=request.json.get('new_pwd')
        old_pwd=request.json.get('old_pwd')
        phone = get_token_phone(request.headers.get('token'))
        data = db.session.execute(text('select * from user where telephone="%s" and password="%s"'% (phone,old_pwd))).fetchall()
        if not data:
            return jsonify(status=1000,msg="原始密码错误")
        else:
            db.session.execute(text('update user set password="%s" where telephone="%s"'% (pwd,phone)))
            db.session.commit()
            return jsonify(status=200,msg="修改成功")


@app.route("/api/manager/shop", methods=["POST", "GET", "DELETE"])
@cross_origin()
def manager_shop():
    # 获取店铺信息
    if request.method == 'GET':
        data = db.session.execute(text('select * from fastfood_shop')).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(shop_name=data[i][0], price=data[i][1], sale=data[i][2])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)
    if request.method == 'POST' and request.json.get('action') == "add":
        rq = request.json
        shop_name = rq.get('shop_name')
        price = rq.get('price')
        m_sale_v = rq.get('m_sale_v')
        exist = db.session.execute(text('select * from fastfood_shop where shop_name="%s"' % shop_name)).fetchall()
        if not exist:
            db.session.execute(text('insert fastfood_shop(shop_name,price,m_sale_v) value("%s",%d,%d)' % (
                shop_name, int(price), int(m_sale_v))))
            db.session.commit()
            return jsonify(status=200, msg="添加成功")
        else:
            return jsonify(status=1000, msg="该店铺已存在")

    if request.method == 'POST' and request.json.get('action') == "change":
        rq = request.json
        shop_name = rq.get('shop_name')
        price = rq.get('price')
        m_sale_v = rq.get('m_sale_v')
        db.session.execute(text('update fastfood_shop set price="%d", m_sale_v="%d" where shop_name="%s" ' % (
            int(price), int(m_sale_v), shop_name)))
        db.session.commit()
        return jsonify(status=200, msg="修改成功")
    if request.method == 'DELETE':
        want_delete = request.json.get('want_delete')
        db.session.execute(text('delete from fastfood_shop where shop_name="%s"' % want_delete))
        db.session.commit()
        return jsonify(status=200, msg="删除成功")


@app.route("/api/manager/server", methods=["POST", "GET", "DELETE"])
@cross_origin()
def manager_server():
    if request.method == 'GET':
        data = db.session.execute(text('select * from server')).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(service_id=data[i][0], service_name=data[i][1], fastfood_shop_name=data[i][2])
            Data.append(dic)
        shop_range = db.session.execute(text('select shop_name from fastfood_shop')).fetchall()
        Shop = []
        for i in range(len(shop_range)):
            dic = dict(shop_name=shop_range[i][0])
            Shop.append(dic)
        print(Shop)
        return jsonify(status=200, tabledata=Data, shop_range=Shop)
    if request.method == 'POST':
        rq = request.json
        service_id = rq.get('service_id')
        service_name = rq.get('service_name')
        fastfood_shop_name = rq.get('fastfood_shop_name')
        exist = db.session.execute(text('select * from server where service_id="%s"' % service_id)).fetchall()
        if not exist:
            db.session.execute(text('insert server(service_id,service_name,fastfood_shop_name) value("%s","%s","%s")' % (
                service_id, service_name, fastfood_shop_name)))
            db.session.commit()
            return jsonify(status=200, msg="添加成功")
        else:
            return jsonify(status=1000, msg="该编号已存在")
    if request.method == 'DELETE':
        want_delete = request.json.get('want_delete')
        db.session.execute(text('delete from server where service_id="%s"' % want_delete))
        db.session.commit()
        return jsonify(status=200, msg="解雇成功")


@app.route("/api/manager/dispatcher", methods=["POST", "GET", "DELETE"])
@cross_origin()
def manager_dispatcher():
    if request.method == 'GET':
        data = db.session.execute(text('select * from dispatcher')).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(dispatcher_id=data[i][0], dispatcher_name=data[i][1], dispatcher_phone=data[i][2])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)
    if request.method == 'POST':
        rq = request.json
        dispatcher_id = rq.get('dispatcher_id')
        dispatcher_name = rq.get('dispatcher_name')
        dispatcher_phone = rq.get('dispatcher_phone')
        exist = db.session.execute(text('select * from dispatcher where dispatcher_id="%s"' % dispatcher_id)).fetchall()
        if not exist:
            db.session.execute(
                text('insert dispatcher(dispatcher_id,dispatcher_name,dispatcher_phone) value("%s","%s","%s")' % (
                    dispatcher_id, dispatcher_name, dispatcher_phone)))
            db.session.commit()
            return jsonify(status=200, msg="添加成功")
        else:
            return jsonify(status=1000, msg="该编号已存在")
    if request.method == 'DELETE':
        want_delete = request.json.get('want_delete')
        db.session.execute(text('delete from dispatcher where dispatcher_id="%s"' % want_delete))
        db.session.commit()
        return jsonify(status=200, msg="解雇成功")


@app.route("/api/manager/wuliu", methods=["GET"])
@cross_origin()
def manager_wuliu():
    ended = request.args.get('id')
    if ended == '0':
        data = db.session.execute(text('select * from wuliu where ended=0')).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(order_id=data[i][0], cons_phone=data[i][1], disp_id=data[i][2], deliver_time=data[i][3])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)
    else:
        data = db.session.execute(text('select * from wuliu where ended=1')).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(order_id=data[i][0], cons_phone=data[i][1], disp_id=data[i][2], deliver_time=data[i][3])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)


@app.route("/api/manager/unsend", methods=["GET", "POST"])
@cross_origin()
def manager_unsend():
    if request.method == 'GET':
        data = db.session.execute(text('select * from oorder where checked=0')).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(order_id=data[i][0], shop_name=data[i][1], price=data[i][2], orderway=data[i][3],
                       cons_phone=data[i][4],
                       cons_name=data[i][5], cons_addre=data[i][6], create_time=data[i][8])
            Data.append(dic)

        disp_range = db.session.execute(text('select * from dispatcher')).fetchall()  # 获取所有的送货员就id，供选择
        Disp_range = []
        for i in range(len(disp_range)):
            dic = dict(disp_id=disp_range[i][0])
            Disp_range.append(dic)
        return jsonify(status=200, tabledata=Data, disp_range=Disp_range)
    if request.method == 'POST':
        rq = request.json
        order_id = rq.get('order_id')
        disp_id = rq.get('dispatcher_id')
        deliver_time = rq.get('deliver_time')
        cons_phone = db.session.execute(text('select cons_phone from oorder where order_id="%d"' % int(order_id))).first()

        db.session.execute(text('insert wuliu( order_id, cons_phone,disp_id,deliver_time) value(%d,"%s","%s","%s")' % (
        int(order_id), cons_phone[0], disp_id, deliver_time)))
        db.session.commit()
        return jsonify(status=200, msg="成功派发")


@app.route("/api/manager/sending", methods=["GET"])
@cross_origin()
def manager_sending():
    if request.method == 'GET':
        data = db.session.execute(text('select * from sending_order')).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(order_id=data[i][0], shop_name=data[i][1], order_money=data[i][2], order_way=data[i][3],
                       cons_phone=data[i][4],
                       cons_name=data[i][5], cons_addre=data[i][6], disp_id=data[i][7], deliver_time=data[i][8])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)


@app.route("/api/manager/sended", methods=["GET"])
@cross_origin()
def manager_sended():
    if request.method == 'GET':
        data = db.session.execute(text('select * from sended_order')).fetchall()
        Data = []
        for i in range(len(data)):
            dic = dict(order_id=data[i][0], shop_name=data[i][1], order_money=data[i][2], order_way=data[i][3],
                       cons_phone=data[i][4],
                       cons_name=data[i][5], cons_addre=data[i][6], disp_id=data[i][7], deliver_time=data[i][8])
            Data.append(dic)
        return jsonify(status=200, tabledata=Data)
    
    
# ============================= 新增：管理员查看所有评论 =============================
@app.route("/api/manager/comments", methods=["GET"])
@cross_origin()
def manager_get_comments():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    shop_name = request.args.get('shop_name', '').strip()
    offset = (page - 1) * per_page

    sql = """
        SELECT 
            comment_id, shop_name, username, telephone, score, content, create_time 
        FROM comments 
        WHERE is_deleted = 0 
    """
    params = {}
    
    if shop_name:
        sql += " AND shop_name LIKE :shop_name"
        params['shop_name'] = f'%{shop_name}%'

    sql += " ORDER BY create_time DESC LIMIT :limit OFFSET :offset"
    params['limit'] = per_page
    params['offset'] = offset

    data = db.session.execute(text(sql), params).fetchall()
    total_sql = "SELECT COUNT(*) FROM comments WHERE is_deleted = 0"
    if shop_name:
        total_sql += " AND shop_name LIKE :shop_name"
        total_result = db.session.execute(text(total_sql), {'shop_name': f'%{shop_name}%'}).scalar()
    else:
        total_result = db.session.execute(text(total_sql)).scalar()

    comments_list = []
    for row in data:
        comments_list.append({
            "comment_id": row[0],
            "shop_name": row[1],
            "username": row[2],
            "telephone": row[3],
            "score": row[4],
            "content": row[5],
            "create_time": row[6].strftime('%Y-%m-%d %H:%M:%S') if row[6] else None
        })

    return jsonify({
        "status": 200,
        "data": comments_list,
        "total": total_result,
        "page": page,
        "per_page": per_page
    }) 
    
# ============================= 新增：用户提交评论 =============================
@app.route("/api/user/add_comment", methods=["POST"])
@cross_origin()
def user_add_comment():
    rq = request.json
    order_id = rq.get("order_id")          # 订单ID（可选，用于关联）
    shop_name = rq.get("shop_name")
    score = rq.get("score")                # 1-5
    content = rq.get("content", "").strip()

    # 从 token 获取当前用户信息
    token = request.headers.get('token')
    if not token:
        return jsonify(status=1000, msg="未登录")
    
    user_info = auth.decode_func(token)
    telephone = user_info.get('telephone')
    username = user_info.get('username')

    if not all([shop_name, score, telephone]):
        return jsonify(status=1000, msg="参数缺失")

    if not 1 <= int(score) <= 5:
        return jsonify(status=1000, msg="评分必须在1-5之间")


# ==============检查该用户是否已经对这个店铺评价过（可选：一个用户只能评一次）================
    exist = db.session.execute(
        text("SELECT 1 FROM comments WHERE shop_name = :shop AND telephone = :tel AND is_deleted = 0"),
        {"shop": shop_name, "tel": telephone}
    ).fetchone()

    if exist:
        return jsonify(status=1000, msg="您已评价过该店铺")

    # 插入评论
    try:
        db.session.execute(
            text("""
                INSERT INTO comments 
                (shop_name, username, telephone, score, content) 
                VALUES (:shop, :username, :tel, :score, :content)
            """),
            {
                "shop": shop_name,
                "username": username,
                "tel": telephone,
                "score": int(score),
                "content": content
            }
        )
        db.session.commit()
        return jsonify(status=200, msg="评价成功")
    except Exception as e:
        db.session.rollback()
        print(e)
        return jsonify(status=1000, msg="评价失败，请重试")


# ============================= 新增：检查用户是否已评价该店铺 =============================
@app.route("/api/user/has_commented", methods=["GET"])
@cross_origin()
def user_has_commented():
    shop_name = request.args.get("shop_name")
    token = request.headers.get('token')
    if not token or not shop_name:
        return jsonify(status=1000, msg="参数错误")

    user_info = auth.decode_func(token)
    telephone = user_info.get('telephone')

    exist = db.session.execute(
        text("SELECT 1 FROM comments WHERE shop_name = :shop AND telephone = :tel AND is_deleted = 0"),
        {"shop": shop_name, "tel": telephone}
    ).fetchone()

    return jsonify(status=200, has_commented=bool(exist))
    
    
# ============================= 新增：管理员删除评论 =============================
@app.route("/api/manager/comments/<int:comment_id>", methods=["DELETE"])
@cross_origin()
def delete_comment(comment_id):
    try:
        result = db.session.execute(
            text("UPDATE comments SET is_deleted = 1 WHERE comment_id = :id"),
            {"id": comment_id}
        )
        if result.rowcount == 0:
            return jsonify(status=1000, msg="评论不存在或已被删除")
        
        db.session.commit()
        
        # 触发器会自动更新店铺 avg_score 和 total_comments
        return jsonify(status=200, msg="删除成功")
    except Exception as e:
        db.session.rollback()
        print(e)  # 建议打印错误，便于调试
        return jsonify(status=1000, msg="删除失败，服务器错误")   
    
# ============================= 新增：管理员确认订单完成 =============================
@app.route("/api/manager/confirm_order_complete", methods=["POST"])
@cross_origin()
def manager_confirm_order_complete():
    rq = request.json
    order_id = rq.get("order_id")

    if not order_id:
        return jsonify(status=1000, msg="订单ID缺失")

    # 更新 oorder 的 checked 为 2（已完成）
    result = db.session.execute(
        text("UPDATE oorder SET checked = 2 WHERE order_id = :oid AND checked = 1"),
        {"oid": int(order_id)}
    )

    if result.rowcount == 0:
        return jsonify(status=1000, msg="订单不存在或已完成")

    db.session.commit()
    return jsonify(status=200, msg="订单已标记为完成")


# ============================= 新增：用户确认收货（将订单标记为已完成） =============================
@app.route("/api/user/confirm_received", methods=["POST"])
@cross_origin()
def user_confirm_received():
    rq = request.json
    order_id = rq.get("order_id")

    if not order_id:
        return jsonify(status=1000, msg="订单ID缺失")

    # 从 token 获取用户手机号，确保只能操作自己的订单
    token = request.headers.get('token')
    if not token:
        return jsonify(status=1000, msg="未登录")

    user_info = auth.decode_func(token)
    cons_phone = user_info.get('telephone')

    # 更新订单状态：checked = 2（已完成），且只能更新自己的、正在进行的订单
    result = db.session.execute(
        text("""
            UPDATE oorder 
            SET checked = 2 
            WHERE order_id = :oid 
              AND cons_phone = :phone 
              AND checked = 1
        """),
        {"oid": int(order_id), "phone": cons_phone}
    )

    if result.rowcount == 0:
        return jsonify(status=1000, msg="订单不存在、无权操作或已完成")

    db.session.commit()
    return jsonify(status=200, msg="订单已完成")

# ============================= 新增：物流完成订单 =============================
@app.route("/api/manager/complete_delivery", methods=["POST"])
@cross_origin()
def complete_delivery():
    order_id = request.json.get("order_id")
    result = db.session.execute(
        text("UPDATE wuliu SET ended = 1 WHERE order_id = :oid AND ended = 0"),
        {"oid": order_id}
    )
    if result.rowcount > 0:
        db.session.commit()
        return jsonify(status=200, msg="已完成")
    return jsonify(status=1000, msg="操作失败")

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port='5000')
    # 开启了debug模式
    
    
    
    
    

