///navigate(node list, start node, end node)

var _node = argument0, _sn = argument1, _en = argument2;
if !(ds_exists(_node, ds_type_list) && instance_exists(_sn) && instance_exists(_en)) { return INSTANCE_NOT_EXIST; }

var _checked = ds_list_create(), _cost = ds_list_create(), _prev = ds_list_create();
var _checkedNode = ds_list_create(); // _checkedNode:우선순위 큐

for(var _i = 0; _i < ds_list_size(_node); _i++) {
    ds_list_add(_checked, 0);
    ds_list_add(_cost, 9999999999);
    ds_list_add(_prev, -1);
}

// dykstra algorithm
_cost[| ds_list_find_index(_node, _sn)] = 0; // set cost of start node to 0 
var __node = _sn; // A node
while(ds_list_find_index(_checked, 0) != -1) { // if exists non-visit node
    var _road;
    show_debug_message("A node: " + string(__node));
    show_debug_message("A node checked?: " + string(_checked[| ds_list_find_index(_node, __node)]));
    for(var _i = 0; _i < ds_list_size(__node.connected); _i++) {
        // set connected node to temp-var; B node
        _road = __node.connected[| _i];
        var _nextNode;
        if (_road[| 1] == IN)
            _nextNode = _road[| 0].bid;
        else
            _nextNode = _road[| 0].eid;
        var __cost = _cost[| ds_list_find_index(_node, __node)] + _road[| 0].length;///_road[| 0].avgSpeed;
        if (__cost < 
            _cost[| ds_list_find_index(_node, _nextNode)]) { // compare cost
            // 갱신
            _cost[| ds_list_find_index(_node, _nextNode)] = __cost;
            _prev[| ds_list_find_index(_node, _nextNode)] = __node;
            if (ds_list_size(_checkedNode) == 0) {
                ds_list_add(_checkedNode, _nextNode);
            } else {
                for(var _j = 0; _j < ds_list_size(_checkedNode); _j++)
                    if(_checked[| ds_list_find_index(_node, _nextNode)] == 0 && _cost[| ds_list_find_index(_node, _checkedNode[| _j])] >= _cost[| ds_list_find_index(_node, _nextNode)])
                        ds_list_insert(_checkedNode, 0, _nextNode); // put priority queue
            }
        }
    }
    
    _checked[| ds_list_find_index(_node, __node)] = 1;
    var count = 0;
    for(var _i = 0; _i < ds_list_size(_checked); _i++)
        if (_checked[| _i] == 0) count++;
    show_debug_message("unchecked count: " + string(count));
    for(var _i = 0; _i < ds_list_size(_cost); _i++)
        show_debug_message("cost[" + string(_i) + "]: " + string(_cost[| _i]));
    
    for(var _j = 0; _j < ds_list_size(_checkedNode); _j++)
        if (_checked[| ds_list_find_index(_node, _checkedNode[| _j])] == 0) {
            __node = _checkedNode[| _j]; // update A node
            break;
        }
    
    if (_checked[| ds_list_find_index(_node, __node)] == 1)
        for(var _i = 0; _i < ds_list_size(_node); _i++)
            if (_checked[| _i] == 0) {
                __node = _node[| _i];
                break;
            }
}

// generate path

var _id = ds_list_find_index(_node, _en), _path = ds_list_create();
ds_list_add(_path, _node[| _id]);
while(true) {
    if (_node[| _id] != _sn) {
        _id = ds_list_find_index(_node, _prev[| _id]);
        ds_list_add(_path, _node[| _id]);
    } else { break; }
}

// return node list
return _path;