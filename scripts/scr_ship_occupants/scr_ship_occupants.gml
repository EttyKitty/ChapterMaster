function ship_occupants_list(target_ship_id) {
	try {
		var carrying_vehicles = [];
		var carrying_units = [];
		var total_carrying = [];
		var carrying_string = "";

		for (var co = 0; co <= 10; co++) {
			for (var i = 0; i < array_length(obj_ini.role[co]); i++) {
				if (obj_ini.role[co][i] != "") {
					var unit = fetch_unit([co, i]);
					if (unit.ship_location == target_ship_id) {
						array_push(carrying_units, unit.role());
					}
				}
			}
		}

		for (var co = 0; co <= 10; co++) {
			for (var i = 0; i < array_length(obj_ini.veh_role[co]); i++) {
				if ((obj_ini.veh_role[co][i] != "") && (obj_ini.veh_lid[co][i] == target_ship_id)) {
					array_push(carrying_vehicles, obj_ini.veh_role[co][i]);
				}
			}
		}

		total_carrying = array_concat(carrying_units, carrying_vehicles);
		total_carrying = count_and_prepend(total_carrying);

		for (var i = 0; i < array_length(total_carrying); i++) {
			carrying_string += "\n" + total_carrying[i];
		}

		return carrying_string;
	} catch (_exception) {
		handle_exception(_exception);
	}
}

function count_and_prepend(array) {
	try {
		var result_array, unique_items, counts, item_name, count, found;
		
		// Arrays to track unique items and their counts
		unique_items = [];
		counts = [];
		
		// Loop through the input array to count occurrences of each item
		for (var i = 0; i < array_length(array); i++) {
			item_name = array[i];
			found = false;
			
			// Check if the item is already in the unique_items array
			for (var j = 0; j < array_length(unique_items); j++) {
				if (unique_items[j] == item_name) {
					counts[j] += 1;
					found = true;
					break;
				}
			}
			
			// If the item was not found, add it to the unique_items array
			if (!found) {
				array_push(unique_items, item_name);
				array_push(counts, 1);
			}
		}
		
		// Create a result array with the count prepended to the item name
		result_array = [];
		for (var i = 0; i < array_length(unique_items); i++) {
			item_name = unique_items[i];
			count = counts[i];
			
			// Prepend the count and add to the result array
			array_push(result_array, $"{item_name} x{count}");
		}
		
		// Return the modified array
		return result_array;
	} catch (_exception) {
		handle_exception(_exception);
	}
}
