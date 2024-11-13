if (gc_timer > 0) {
    gc_timer -= delta_time/1000000;
    // show_debug_message($"obj_garbage_collector: gc_timer = {gc_timer}");
} else {
    gc_timer = 60;
    gc_collect();

    wait_and_execute(0, function(){
        var _gc_stats = gc_get_stats();
        var _gc_touched = $"GC: Objects Touched: {_gc_stats.objects_touched}";
        var _gc_collected = $"GC: Objects Collected: {_gc_stats.objects_collected}";
        var _gc_traversal_t = $"GC: Traversal Time: {_gc_stats.traversal_time} μs";
        var _gc_collection_t = $"GC: Collection Time: {_gc_stats.collection_time} μs";
        var _gc_lines = [_gc_touched, _gc_collected, _gc_traversal_t, _gc_collection_t];
        show_debug_message_time($"GC: Garbage Collected!");
        array_foreach(_gc_lines, debugl);
    });
}