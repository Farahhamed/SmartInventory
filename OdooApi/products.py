from flask import jsonify, request
import connection as con

models = None
db = None
uid = None
password = None

with con.app.app_context():
    models, db, uid, password = con.connect_to_odoo()

@con.app.route('/get_products', methods=['GET'])
def get_products():
    #models, db, uid, password = con.connect_to_odoo()
    record_ids = models.execute_kw(db, uid, password, 'product.template', 'search', [[]])
    records = models.execute_kw(db, uid, password, 'product.template', 'read', [record_ids], {'fields': ['name', 'list_price']})
    
    return jsonify(records)

@con.app.route('/add_product', methods=['POST'])
def add_product():
    try:
        #models, db, uid, password = con.connect_to_odoo()

        # Extract product details from the request JSON data
        data = request.json
        product_name = data.get('name')
        list_price = data.get('list_price')
        #category_id = data.get('category_id')  # Assuming you'll send category ID in the request

        # Create a new product
        new_product_id = models.execute_kw(
            db, uid, password, 'product.template', 'create',
            [{'name': product_name, 'list_price': list_price}]
        )

        return jsonify({'status': 'success', 'product_id': new_product_id})

    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})


@con.app.route('/update_product', methods=['PUT'])
def update_product():
    try:
        #models, db, uid, password = con.connect_to_odoo()

        # Extract product details from the request JSON data
        data = request.json
        product_id = data.get('product_id')
        new_name = data.get('new_name')
        new_list_price = data.get('new_list_price')

        # Check if the product exists
        if not models.execute_kw(db, uid, password, 'product.template', 'search_count', [[('id', '=', product_id)]]):
            return jsonify({'status': 'error', 'message': 'Product not found'})

        # Update product details
        models.execute_kw(
            db, uid, password, 'product.template', 'write',
            [[product_id], {'name': new_name, 'list_price': new_list_price}]
        )

        return jsonify({'status': 'success', 'message': 'Product details updated'})

    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})

@con.app.route('/delete_product/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    #models, db, uid, password = con.connect_to_odoo()

    # Check if the product exists
    product_exists = models.execute_kw(db, uid, password, 'product.template', 'search_count', [[('id', '=', product_id)]])
    if not product_exists:
        return jsonify({'error': 'Product not found'}), 404

    # Delete the product
    try:
        models.execute_kw(db, uid, password, 'product.template', 'unlink', [[product_id]])
        return jsonify({'message': 'Product deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    con.app.run(debug=True)