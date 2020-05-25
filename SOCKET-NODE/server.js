const express= require("express");
const app=express();
const http=require('http');
const socketIo=require('socket.io');

app.get('/',(req,res)=>res.send("hiiiii"));

const server=http.Server(app);
server.listen(3000);

const io=socketIo(server);

io.on('connection',(socket)=>{

    socket.emit('hi',{

        greeting:"hiii"
    })
})