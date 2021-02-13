const path = require('path');
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');
const { PanoramaManifestPlugin, PanoramaTargetPlugin } = require('webpack-panorama');

/** @type {import('webpack').Configuration} */
module.exports = {
	mode: 'development', // production, development
	context: path.resolve(__dirname, 'src'),
	output: {
		path: path.resolve(__dirname, 'layout/custom_game'),
		publicPath: 'file://{resources}/layout/custom_game/',
	},

	module: {
		rules: [
			{
				test: /\.xml$/,
				loader: 'webpack-panorama/lib/layout-loader',
			},
			{
				test: /\.[jt]sx$/,
				issuer: /\.xml$/,
				loader: 'webpack-panorama/lib/entry-loader',
			},
			{
				test: /\.tsx?$/,
				loader: 'ts-loader',
				options: { transpileOnly: true },
			},
			{
				test: /\.js?$|\.jsx?$/,
				loader: 'babel-loader',
				options: { presets: ['@babel/preset-react', '@babel/preset-env'] },
			},
			{
				test: /\.css$/,
				test: /\.(css|less)$/,
				issuer: /\.xml$/,
				loader: 'file-loader',
				options: { name: '[path][name].css', esModule: false },
			},
			{
				test: /\.less$/,
				loader: 'less-loader',
				options: {
					lessOptions: {
						relativeUrls: false,
					}
				}
			},
		],
	},

	resolve: {
		extensions: ['.ts', '.tsx', '.js', '.jsx', '...'],
		symlinks: false,
	},

	entry: {
		store: {
			import: './store/layout.xml',
			filename: 'store/store.xml',
		},
		inventory: {
			import: './inventory/layout.xml',
			filename: 'inventory/inventory.xml',
		},
		popup_store_item: { import: './popups/popup_store_item/layout.xml', filename: 'popups/popup_store_item/popup_store_item.xml' },
		popup_inventory_item: { import: './popups/popup_inventory_item/layout.xml', filename: 'popups/popup_inventory_item/popup_inventory_item.xml' },
		popus_recharge: { import: './popups/popus_recharge/layout.xml', filename: 'popups/popus_recharge/popus_recharge.xml' },
	},

	plugins: [
		new PanoramaTargetPlugin(),
		// new PanoramaManifestPlugin({
		// 	minify: {
		// 		caseSensitive: true,
		// 		keepClosingSlash: true,
		// 	},
		// 	entries: ((() => {
		// 		let list = [
		// 			{
		// 				import: './manifest.jsx',
		// 				filename: 'manifest/manifest.js'
		// 			},
		// 			{
		// 				import: './custom_loading_screen/layout.xml', filename: 'custom_loading_screen.xml',
		// 			},
		// 			{
		// 				import: './compile.xml', filename: 'compile.xml',
		// 			},
		// 			{ import: './hud_main/layout.xml', type: 'Hud' },
		// 			// { import: './hud_demo/layout.xml', type: 'Hud' },
		// 			// { import: './build/layout.xml', type: 'Hud' },
		// 			{ import: './ui_particles/layout.xml', type: 'Hud' },
		// 			// { import: './overhead/layout.xml', type: 'Hud' },
		// 			// { import: './ability_upgrades_selection/layout.xml', type: 'Hud' },
		// 			{ import: './hero_selection/layout.xml', type: 'HeroSelection' },
		// 		]
		// 		let tooltips = ['tooltip_ability', 'unit_stats'];
		// 		// let contextMenus = ['context_menu_inventory_item'];

		// 		tooltips.forEach(tooltipName => {
		// 			list.push({
		// 				import: './tooltips/' + tooltipName + '/layout.xml',
		// 				filename: 'tooltips/' + tooltipName + '/' + tooltipName + '.xml',
		// 			})
		// 		});
		// 		// contextMenus.forEach(contextMenuName => {
		// 		// 	list.push({
		// 		// 		import: './context_menu/' + contextMenuName + '/layout.xml',
		// 		// 		filename: 'context_menu/' + contextMenuName + '/' + contextMenuName + '.xml',
		// 		// 	})
		// 		// });
		// 		return list;
		// 	})()),
		// }),
		new ForkTsCheckerWebpackPlugin({
			typescript: {
				configFile: path.resolve(__dirname, "tsconfig.json"),
			},
		}),
	],
};