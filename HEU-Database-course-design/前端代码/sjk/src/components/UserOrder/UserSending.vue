<template>
  <div>
    <div class="header">
      进行中订单（已发货）
    </div>
    <div class="body">
      <el-table :data="tableData" style="width: 100%" class="table" border>
        <el-table-column prop="shop_name" label="店铺" width="100" align="center"></el-table-column>
        <el-table-column prop="order_money" label="订单价格" width="80" align="center"></el-table-column>
        <el-table-column prop="order_way" label="订餐方式" width="100" align="center"></el-table-column>
        <el-table-column prop="cons_name" label="订餐人姓名" width="100" align="center"></el-table-column>
        <el-table-column prop="cons_addre" label="取餐地址" width="150" align="center"></el-table-column>
        <el-table-column prop="disp_id" label="送餐员编号" width="120" align="center"></el-table-column>
        <el-table-column prop="disp_phone" label="送餐员电话" width="120" align="center"></el-table-column>
        <el-table-column prop="deliver_time" label="预计送餐时间" width="116" align="center"></el-table-column>

        <!-- 新增：确认收货操作列 -->
        <el-table-column label="操作" width="120" align="center">
          <template slot-scope="scope">
            <el-popconfirm
                title="您已收到餐品了吗？确认后订单将完成"
                confirm-button-text="已收到"
                cancel-button-text="还未收到"
                @confirm="confirmReceived(scope.row.order_id)"
            >
              <el-button slot="reference" type="success" size="small">
                确认收货
              </el-button>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
export default {
  created() {
    this.getdata()
  },
  data() {
    return {
      tableData: [],
    }
  },
  methods: {
    getdata() {
      this.$axios.get("/api/user/sending", {
        headers: { token: localStorage.getItem('token') }
      }).then((res) => {
        console.log(res.data);
        if (res.data.status === 200) {
          this.tableData = res.data.tabledata || [];
        }
      }).catch(() => {
        this.$message.error('加载订单失败');
      });
    },

    // 用户确认收货
    confirmReceived(order_id) {
      this.$axios.post("/api/user/confirm_received", {
        order_id: order_id
      }, {
        headers: { token: localStorage.getItem('token') }
      }).then((res) => {
        if (res.data.status === 200) {
          this.$message.success('订单已完成！感谢使用~');
          // 刷新列表，该订单会自动消失
          this.getdata();
        } else {
          this.$message.error(res.data.msg || '操作失败');
        }
      }).catch(() => {
        this.$message.error('网络错误，请重试');
      });
    }
  }
}
</script>

<style scoped>
.header {
  width: 100%;
  height: 10%;
  text-align: center;
  line-height: 64px;
  font-size: 20px;
  font-weight: 800;
  border-bottom: 1px solid #e3e3e3;
}

.body {
  width: 80%;           /* 稍微放宽一点，更美观 */
  margin: auto;
  margin-top: 30px;
}
</style>