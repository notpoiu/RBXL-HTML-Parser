local a={cache={}::any}do do local function __modImpl()



local b={}
b.mt={__index=b}

function b.new(d,e)
local f={}
local h
if getmetatable(e)==b.mt then h=true end

if type(e)=="table"then
if not h and#e>0 then
for i,j in ipairs(e)do f[j]=true end
else
for i in pairs(e)do f[i]=true end
end
elseif e~=nil then
f={[e]=true}
end
return setmetatable(f,b.mt)
end

function b.add(d,e)
if e~=nil then d[e]=true end

return d
end

function b.remove(d,e)
if e~=nil then d[e]=nil end

return d
end

function b.tolist(d)
local e={}
for f in pairs(d)do table.insert(e,f)end
return e
end

b.to_list=b.tolist

b.mt.__add=function(d,e)
local f,h,i=b:new(),b:new(d),b:new(e)
for j in pairs(h)do f[j]=true end
for j in pairs(i)do f[j]=true end
return f
end


b.mt.__sub=function(d,e)
local f,h,i=b:new(),b:new(d),b:new(e)
for j in pairs(h)do f[j]=true end
for j in pairs(i)do f[j]=nil end
return f
end


b.mt.__mul=function(d,e)
local f,h,i=b:new(),b:new(d),b:new(e)
for j in pairs(h)do f[j]=i[j]end
return f
end


b.mt.__tostring=function(d)
local e="{"
local f=""
for h in pairs(d)do
e=e..f..tostring(h)
f=", "
end
return e.."}"
end

local d={}
d.mt={__index=d}
function d.new(e,f,h,i,j,k,l)
local m={
index=f,
name=h,
level=0,
parent=nil,
root=nil,
nodes={},
_openstart=k,
_openend=l,
_closestart=k,
_closeend=l,
attributes={},
id=nil,
classes={},
deepernodes=b:new(),
deeperelements={},
deeperattributes={},
deeperids={},
deeperclasses={}
}

m.attrs=m.attributes
m.children=m.nodes
m.descendants=m.deepernodes
m.descendant_elements=m.deeperelements
m.descendant_attrs=m.deeperattributes
m.descendent_ids=m.deeperids
m.descendant_classes=m.deeperclasses

if not i then
m.name="root"
m.root=m
m._text=h
local n=string.len(h)
m._openstart,m._openend=1,n
m._closestart,m._closeend=1,n
elseif j then
m.root=i.root
m.parent=i
m.level=i.level+1
table.insert(i.nodes,m)
else
m.root=i.root
m.parent=i.parent or i
m.level=i.level
table.insert((i.parent and i.parent.nodes or i.nodes),m)
end
return setmetatable(m,d.mt)
end

function d.text(e)
return string.sub(e.root._text,e._openstart,e._closeend)
end
d.gettext=d.text

function d.settext(e,f)e.root._text=f end

function d.textonly(e)return(e:text():gsub("<[^>]*>",""))end

function d.content(e)
return string.sub(e.root._text,e._openend+1,e._closestart-1)
end
d.getcontent=d.content

function d.addattribute(e,f,h)
e.attributes[f]=h
if string.lower(f)=="id"then
e.id=h

elseif string.lower(f)=="class"then
for i in string.gmatch(h,"%S+")do
table.insert(e.classes,i)
end
end
end

function d.links(e)
local f={}

for h,i in ipairs(e:select"a[href]")do
if#i.attributes.href>0 then
table.insert(f,i.attributes.href)
end
end

return f
end

function d.absolutelinks(e,f)

local h=f:split"://"
h=h[#h]
h=h:split"/"[1]

local i=f:find"://"and f:split"://"[1]or"http"

while f:sub(-1,-1)=="/"do
f=f:sub(1,-2)
end

local j={}

for k,l in ipairs(e:select"a[href]")do
if#l.attributes.href>0 then
local m=l.attributes.href

if not m:find"://"then
if m:sub(1,2)=="//"then
m=i..":"..m
elseif m:sub(1,1)=="/"then
m=i.."://"..h..m
else
m=f.."/"..m
end
end

table.insert(j,m)
end
end

return j
end

d.absolute_links=d.absolutelinks


local function insert(e,f,h)
e[f]=e[f]or b:new()
e[f]:add(h)
end

function d.close(e,f,h)
if f and h then
e._closestart,e._closeend=f,h
end

local i=e
while true do
i=i.parent
if not i then break end
i.deepernodes:add(e)
insert(i.deeperelements,e.name,e)
for j in pairs(e.attributes)do
insert(i.deeperattributes,j,e)
end
if e.id then insert(i.deeperids,e.id,e)end
for j,k in ipairs(e.classes)do
insert(i.deeperclasses,k,e)
end
end
end

local function escape(e)

return string.gsub(e,"([%^%$%(%)%%%.%[%]%*%+%-%?])",'%%%1')
end

local function select(e,f)
if not f or type(f)~="string"or f==""then return b:new()end
local h={
[""]=e.deeperelements,
["["]=e.deeperattributes,
["#"]=e.deeperids,
["."]=e.deeperclasses
}
local function match(i,j)
local k,l,m
if i=="["then
j,k,l,m=string.match(j,'([^=|%*~%$!%^]+)([|%*~%$!%^]?)(=?)(.*)'




)
end
local n=b:new(h[i][j])

if l=="="then
if#m<2 then m="'"..m.."'"end
m=string.sub(m,2,#m-1)
if k=="!"then n=b:new(e.deepernodes)end
for o in pairs(n)do
local p=o.attributes[j]

if k==""and p~=m then
n:remove(o)

elseif k=="!"and p==m then
n:remove(o)

elseif k=="|"and string.match(p,"^[^-]*")~=m then
n:remove(o)

elseif k=="*"and string.match(p,escape(m))~=m then
n:remove(o)

elseif k=="~"then
n:remove(o)
for q in string.gmatch(p,"%S+")do
if q==m then
n:add(o)
break
end
end

elseif k=="^"and string.match(p,"^"..escape(m))~=m then
n:remove(o)

elseif k=="$"and string.match(p,escape(m).."$")~=m then
n:remove(o)
end
end
end
return n
end

local i,j,k=b:new{e}
for l in string.gmatch(f,"%S+")do
repeat
if l==">"then
k=true
break
end
j=b:new()
for m in pairs(i)do
local n=m.deepernodes
if k then
n=b:new(m.nodes)
end
j=j+n
end
k=false
if l=="*"then break end
local m,n=b:new()
local o,p=0,0
while true do
local q,r,s,t,u
o,p,q,r,s,t,u=
string.find(l,'(%(?%)?)([:%[#.]?)([%w-_\\]+)([|%*~%$!%^]?=?)([\'"]?)'




,
p+1)

if not s then break end

repeat
if":"==r then
n=s

break
end

if")"==q then
n=nil
end

if"["==r and""~=u then
local v
o,p,v=
string.find(l,"(%b"..u..u..")]",
p)
s=s..t..v
end
local v=match(r,s)
if n=="not"then
m=m+v
else
j=j*v
end

break
until true
end
j=j-m
i=b:new(j)

break
until true
end
j=j:tolist()
table.sort(j,function(l,m)
return l.index<m.index
end)
return j
end

function d.select(e,f)
return select(e,f)
end
d.mt.__call=select

return d end function a.a():typeof(__modImpl())local b=a.cache.a if not b then b={c=__modImpl()}a.cache.a=b end return b.c end end do local function __modImpl()


return{
area=true,
base=true,
br=true,
col=true,
command=true,
embed=true,
hr=true,
img=true,
input=true,
keygen=true,
link=true,
meta=true,
param=true,
source=true,
track=true,
wbr=true
}end function a.b():typeof(__modImpl())local b=a.cache.b if not b then b={c=__modImpl()}a.cache.b=b end return b.c end end end






local function rine(b)
return(b and#b>0)and b
end




local b=function()end



local d=tostring
local e=string.char
local f={}

local h=f.silent and b or function(h,i,...)local j=
(h=="i")and"stdout"or"stderr"
local k=(" [%s] "):format(h:upper())
print('[HTMLParser]'..k..i:format(...)..(f.nonl or"\n"))
end

local i=f.noerr and b or function(i,...)
h("e",i,...)
end local j=

f.noout and b or function(j,...)
h("i",j,...)
end
local k=b
local l=f.debug and
function(l,...)
h("d",l:gsub("#LINE#",d(k(3))),...)
end or b



local m=a.a()
local n=a.b()


local o={}

local function parse(p,q)
local r=
rine(f)
or{}
or{}
r.looplimit=r.looplimit or 100000

local s=d(p)
local t=q or r.looplimit or 100000
local u=false

if not r.keep_comments then
s=s:gsub("<!%-%-.-%-%->","")
end


local v={}

if not r.keep_danger_placeholders then

local w,x={},0;
repeat
local y=e(x)
if not(s:match(y))then
if not(v["<"])or not(v[">"])then
if not(w[x])then
if not(v["<"])then
v["<"]=y;
elseif not(v[">"])then
v[">"]=y;
end
w[x]=true
l("c:{%s}||cc:{%d}||tpr[c]:{%s}",d(c),y:byte(),
d(v[c]))
l("busy[i]:{%s},i:{%d}",d(w[x]),x)
l("[FindPH]:#LINE# Success! || i=%d",x)
else
l("[FindPH]:#LINE# Busy! || i=%d",x)
end
l("c:{%s}||cc:{%d}||tpr[c]:{%s}",c,y:byte(),
d(v[c]))
l("%s",d(w[x]))
else
l("[FindPH]:#LINE# Done!",x)
break
end
else
l("[FindPH]:#LINE# Text contains this byte! || i=%d",x)
end
local z=1
if x==31 then
z=96
end
x=x+z
until(x==255)
x=nil


if not(v["<"])or not(v[">"])then
i
"Impossible to find at least two unused byte codes in this HTML-code. We need it to escape bracket-contained placeholders inside tags."
i
"Consider enabling 'keep_danger_placeholders' option (to silence this error, if parser wasn't failed with current HTML-code) or manually replace few random bytes, to free up the codes."
else
l("[FindPH]:#LINE# Found! || '<'=%d, '>'=%d",v["<"]:byte(),
v[">"]:byte())
end




local function g(y,...)
local z={...}
local A=z[y]
z[y]=z[y]:gsub("(.)",v)
if z[y]~=A then
u=true
l("[g]:#LINE# orig: %s",d(A))
l("[g]:#LINE# replaced: %s",d(z[y]))
end
l("[g]:#LINE# called, id: %s, arg[id]: %s, args { "..
(("{%s}, "):rep(#z):gsub(", $","")).." }",y,z[y],
...)
l("[g]:#LINE# concat(arg): %s",table.concat(z))
return table.concat(z)
end



s=s:gsub("(=[%s]-)(%b'')"

,function(...)return g(2,...)end):gsub('(=[%s]-)(%b"")'

,function(...)return g(2,...)end)
:gsub("(<"..
(r.tpl_skip_pattern or"[^!]")..')([^>]+)(>)'

,function(...)return g(2,...)end):gsub(
"("..(v["<"]or"__FAILED__")..
")("..(r.tpl_marker_pattern or"[^%w%s]")..')([%g%s]-)(%2)(>)([^>]*>)'


,
function(...)return g(5,...)end)

end

local w=0
local x=m:new(w,d(s))
local y,z,A,B=x,true,1,{}

while true do
if w==t then
i(
"Main loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors",
t)
break
end

local C,D
C,A,D=x._text:find('<([%w-]+)[^>]*>'


,
A)
l("[MainLoop]:#LINE# openstart=%s || tpos=%s || name=%s",
d(C),d(A),d(D))

if not D then break end

w=w+1
local E=m:new(w,d(D),(y or{}),z,
C,A)
y=E
local F
local G,H=E:gettext(),1

while true do
if F==t then
i(
"Tag parsing loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors",
t)
break
end

local I,J,K,L,M,N
I,H,J,N,K,N,L=
G:find('%s+([^%s=/>]+)([%s]-)(=?)([%s]-)([\'"]?)'




,
H)
l(
"[TagLoop]:#LINE# start=%s || apos=%s || k=%s || zsp='%s' || eq='%s', quote=[%s]",
d(I),d(H),d(J),d(N),d(K),d(L))

if not J or J=="/>"or J==">"then break end

if K=="="then
local O="=([^%s>]*)"
if L~=""then
O=L.."([^"..L.."]*)"..L
end
I,H,M=G:find(O,H)
l(
"[TagLoop]:#LINE# start=%s || apos=%s || v=%s || pattern=%s",
d(I),d(H),d(M),d(O))
end

M=M or""
if u then
for O,P in pairs(v)do
M=M:gsub(P,O)
l("[TagLoop]:#LINE# rv=%s || rk=%s",d(P),d(O))
end
end

l("[TagLoop]:#LINE# k=%s || v=%s",d(J),d(M))
E:addattribute(J,M)
F=(F or 0)+1
end

if n[E.name:lower()]then
z=false
E:close()
else
B[E.name]=B[E.name]or{}
table.insert(B[E.name],E)
end

local I=A
local J
while true do
if J==t then
i(
"Tag closing loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors",
t)
break
end

local K,L,M
K,I,L,M=
x._text:find("[^<]*<(/?)([%w-]+)",I)
l(
"[TagCloseLoop]:#LINE# closestart=%s || closeend=%s || closing=%s || closename=%s",
d(K),d(I),d(L),d(M))

if not L or L==""then break end

E=table.remove(B[M]or{})or E
K=x._text:find("<",K)
l("[TagCloseLoop]:#LINE# closestart=%s",d(K))
E:close(K,I+1)
y=E.parent
z=true
J=(J or 0)+1
end
end
if u then
l"tpl"
for C,D in pairs(v)do x._text=x._text:gsub(D,C)end
end
return x
end
o.parse=parse
return o