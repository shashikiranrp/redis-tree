redis-tree
==========

Tree model in REDIS
===================

<pre>
Represneting of Node: 
  Node -\
        |-- data -> Data object's Key in REDIS  
        |
        |-- children -> Object's Key of children node collection in REDIS
        |
        |-- parent -> Parent node object Key in REDIS
        |
        |-- meta -> Meta information object Key in REDIS (Optional).
        .
</pre>

The above Node can be represented as REDIS HASH type. 
The scripts in this project will assume this model.
