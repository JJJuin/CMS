package com.qdu.websocket;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import org.springframework.beans.factory.annotation.Autowired;
import com.qdu.service.MessageService;
import com.qdu.serviceimpl.MessageServiceImpl;

@ServerEndpoint(value="/websocket.do")
public class WebSocketConnection {
	
	private String userId;
	
	private static ConcurrentHashMap<String, Session> userSocket = new ConcurrentHashMap<>();
	
	@Autowired
	private MessageServiceImpl messageServiceImpl;
	

	 //连接时执行
	@OnOpen
	public void onOpen() throws IOException{
       System.err.println("websocket 链接成功..");
    }
	
	//关闭时执行
    @OnClose
    public void onClose(){
    	System.err.println("websocket 链接关闭..");
    	//这里可以统计在线用户
    }
    
    //收到消息时执行
    @OnMessage
    public void onMessage(String userId, Session session) throws IOException {
       this.userId = userId;
       System.err.println(userId);	   
       Session session2 = session;
       userSocket.put(userId, session2);
	    }
    
    //连接错误时执行
    @OnError
    public void onError(Session session, Throwable error){
        System.err.println(error);
    } 
    
    public static Boolean sendMessageToUser(String userId, String message){
    	try {
			if(userSocket.get(userId) != null){
				userSocket.get(userId).getBasicRemote().sendText(message);
				return true;
			}else {
				return false; 
			} 
		} catch (Exception e) {
			e.printStackTrace();
		}
    	return false;
    }



}
