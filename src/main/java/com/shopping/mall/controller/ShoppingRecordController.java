package com.shopping.mall.controller;


import com.shopping.mall.domain.Constant;
import com.shopping.mall.domain.Products;
import com.shopping.mall.domain.ShoppingCar;
import com.shopping.mall.domain.ShoppingRecord;
import com.shopping.mall.service.ProductsService;
import com.shopping.mall.service.ShoppingRecordService;
import net.minidev.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import tk.mybatis.mapper.entity.Condition;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by CodeGenerator on 2018/02/02.
 */
@Controller
public class ShoppingRecordController {
    @Resource
    private ShoppingRecordService shoppingRecordService;
    @Resource
    private ProductsService productService;

    @RequestMapping(value = "/shopping_record")
    public String shoppingRecord() {
        return "shopping_record";
    }

    @RequestMapping(value = "/shopping_handle")
    public String shoppingHandle() {
        return "shopping_handle";
    }

    @RequestMapping(value = "/addShoppingRecord", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> addShoppingRecord(int userId, int productId, int counts) {
        String result;
        Products product = productService.findById(productId);
        if (counts <= product.getCounts()) {
            ShoppingRecord shoppingRecord = new ShoppingRecord();
            shoppingRecord.setUserId(userId);
            shoppingRecord.setProductId(productId);
            shoppingRecord.setProductPrice(product.getPrice() * counts);
            shoppingRecord.setCounts(counts);
            shoppingRecord.setOrderStatus(0);
            Date date = new Date();
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss");
            shoppingRecord.setTime(sf.format(date));
            product.setCounts(product.getCounts() - counts);
            productService.update(product);
            shoppingRecordService.save(shoppingRecord);
            result = Constant.SUCCESS;
        } else {
            result = "unEnough";
        }
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put(Constant.RESULT, result);
        return resultMap;
    }

    @RequestMapping(value = "/changeShoppingRecord", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> changeShoppingRecord(int userId, int productId, String time, int orderStatus) {
        Condition condition = new Condition(ShoppingCar.class);
        condition.createCriteria().andCondition("user_id = ", userId).andCondition("product_id = ", productId).andCondition("time = ", time);
        ShoppingRecord shoppingRecord = shoppingRecordService.findByCondition(condition).get(0);
        shoppingRecord.setOrderStatus(orderStatus);
        shoppingRecordService.update(shoppingRecord);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put(Constant.RESULT, Constant.SUCCESS);
        return resultMap;
    }

    @RequestMapping(value = "/getShoppingRecords", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getShoppingRecords(int userId) {
        List<ShoppingRecord> shoppingRecordList = shoppingRecordService.findByUserId(userId);
        String shoppingRecords = JSONArray.toJSONString(shoppingRecordList);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put(Constant.RESULT, shoppingRecords);
        return resultMap;
    }

    @RequestMapping(value = "/getShoppingRecordsByOrderStatus", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getShoppingRecordsByOrderStatus(int orderStatus) {
        Condition condition = new Condition(ShoppingCar.class);
        condition.createCriteria().andCondition("order_status", orderStatus);
        List<ShoppingRecord> shoppingRecordList = shoppingRecordService.findByCondition(condition);
        String shoppingRecords = JSONArray.toJSONString(shoppingRecordList);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put(Constant.RESULT, shoppingRecords);
        return resultMap;
    }

    @RequestMapping(value = "/getAllShoppingRecords", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getAllShoppingRecords() {
        List<ShoppingRecord> shoppingRecordList = shoppingRecordService.findAll();
        String shoppingRecords = JSONArray.toJSONString(shoppingRecordList);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put(Constant.RESULT, shoppingRecords);
        return resultMap;
    }

    @RequestMapping(value = "/getUserProductRecord", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getUserProductRecord(int userId, int productId) {
        String result = "false";
        if (shoppingRecordService.getUserProductRecord(userId, productId)) {
            result = "true";
        }
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put(Constant.RESULT, result);
        return resultMap;
    }

}