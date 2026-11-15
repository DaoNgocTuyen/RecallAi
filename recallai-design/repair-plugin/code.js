(async () => {
  const screenIds = ['10:1653', '10:1665', '10:1677', '10:1689', '10:1701'];
  const names = ['01 · Chào mừng', '02 · Khám phá RecallAI', '03 · Đăng nhập', '04 · Chọn vai trò', '05 · Trang chủ học sinh'];
  try {
    const nodes = await Promise.all(screenIds.map(id => figma.getNodeByIdAsync(id)));
    // Stop before editing if the previously verified screens have been removed.
    if (nodes.some(n => !n || n.type !== 'FRAME')) {
      throw new Error('Không tìm thấy đủ năm màn hình đã tạo. Chưa thay đổi thiết kế.');
    }
    let page = nodes[0].parent;
    while (page && page.type !== 'PAGE') page = page.parent;
    if (!page || nodes.some(n => {
      let p = n.parent;
      while (p && p.type !== 'PAGE') p = p.parent;
      return p !== page;
    })) throw new Error('Năm màn hình cần nằm trên cùng một trang. Chưa thay đổi thiết kế.');
    await figma.setCurrentPageAsync(page);
    const fontMap = new Map();
    for (const frame of nodes) {
      for (const text of frame.findAllWithCriteria({types: ['TEXT']})) {
        for (const segment of text.getStyledTextSegments(['fontName'])) {
          fontMap.set(JSON.stringify(segment.fontName), segment.fontName);
        }
      }
    }
    await Promise.all([...fontMap.values()].map(font => figma.loadFontAsync(font)));
    const title = 'RecallAI – Mobile App Screens';
    let section = page.children.find(n => n.type === 'SECTION' && n.name === title);
    const isNew = !section;
    if (!section) {
      const right = Math.max(0, ...page.children.map(n => n.x + n.width));
      section = figma.createSection();
      section.name = title;
      section.x = right + 160;
      section.y = 0;
    }
    section.fills = [{type: 'SOLID', color: {r: 235/255, g: 245/255, b: 240/255}}];
    section.resizeWithoutConstraints(2262, 1004);
    nodes.forEach((frame, i) => {
      section.appendChild(frame);
      frame.name = names[i];
      frame.resize(390, 844);
      frame.x = 48 + i * 438;
      frame.y = 80;
      frame.visible = true;
      frame.clipsContent = true;
    });
    const roleText = nodes[3].findAllWithCriteria({types: ['TEXT']}).find(t =>
      t.characters === 'Chọn vai trò để chúng mình cá nhân hóa trải nghiệm cho bạn.');
    if (roleText) roleText.characters = 'Chọn vai trò phù hợp để bắt đầu hành trình của bạn.';
    const dashboard = nodes[4];
    const viewport = dashboard.findOne(n => n.name === 'Viewport / vertical scroll');
    const feed = dashboard.findOne(n => n.name === 'Feed / Auto Layout');
    if (viewport && viewport.type === 'FRAME') {
      viewport.overflowDirection = 'VERTICAL';
      viewport.clipsContent = true;
    }
    if (feed && feed.type === 'FRAME' && feed.layoutMode === 'VERTICAL') {
      feed.paddingBottom = Math.max(feed.paddingBottom, 24);
    }
    const flowName = 'RecallAI · Hành trình học sinh';
    page.flowStartingPoints = [...page.flowStartingPoints.filter(p => p.nodeId !== nodes[0].id), {nodeId: nodes[0].id, name: flowName}];
    const evidence = nodes.map(n => ({name: n.name, id: n.id, width: n.width, height: n.height,
      textNodes: n.findAllWithCriteria({types: ['TEXT']}).length,
      instances: n.findAllWithCriteria({types: ['INSTANCE']}).length,
      interactions: n.findAll(c => 'reactions' in c && c.reactions.length > 0).length}));
    console.log('RecallAI organization evidence', {section: section.id, isNew, screens: evidence});
    figma.currentPage.selection = nodes;
    figma.viewport.scrollAndZoomIntoView(nodes);
    figma.closePlugin('Đã sắp xếp năm màn hình RecallAI. Thư viện và liên kết mẫu được giữ nguyên.');
  } catch (error) {
    console.error(error);
    figma.closePlugin('RecallAI: ' + (error.message || String(error)));
  }
})();
