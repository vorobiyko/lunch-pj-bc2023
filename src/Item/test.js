

let brickNodeList =  window.parent.document.getElementsByClassName('content')[0].children;
setTimeout(()=>{
for (let i=0; i<brickNodeList.length; i=i+1){
    console.log(brickNodeList.item(i))
    brickNodeList.item(i).style.borderRadius = '15px';
    brickNodeList.item(i).ariaHidden = false;
}
},0);